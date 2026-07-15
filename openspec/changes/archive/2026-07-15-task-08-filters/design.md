## Context

В `vacancy-service` уже работают справочники HH (регионы, профессии, отрасли, метро, языки) с hourly sync через Celery beat. Internal API отдаёт read-only данные по `/internal/dictionaries/*`. Прокси в `main-be` передаёт запросы от авторизованного пользователя.

Следующий шаг — дать пользователю возможность сохранять наборы параметров поиска вакансий (пресеты фильтров) и быстро применять их. Все не-deprecated query-параметры `GET /vacancies` из `docs/hh_openapi.yml` должны быть представлены нормализованно в БД.

## Goals / Non-Goals

**Goals:**

- Нормализованное хранение пресетов фильтров в PostgreSQL с привязкой к HH user ID.
- CRUD internal API в `vacancy-service` для управления пресетами.
- Прокси CRUD через `main-be` с cookie-auth.
- UI Drawer в `main-fe` с формой всех не-deprecated фильтров, управлением пресетами и кнопками.

**Non-Goals:**

- Фактический поиск вакансий по фильтрам (task-09).
- Индексация или полнотекстовый поиск по пресетам.
- Миграция «старых» пресетов (до task-08 их не было).



## Decisions



### 1. Нормализованная модель вместо JSONB

**Решение:** Каждый скалярный параметр — отдельная колонка в таблице `filter_presets`. Мультиселект-параметры (area, professional_role, industry, metro, label, experience, employment_form, work_format, work_schedule_by_days, working_hours, education, salary_frequency, driver_license_types, search_field) — отдельная дочерняя таблица `filter_preset_values` с полем `parameter_name` и `value`.

**Альтернатива:** Единое JSONB-поле `filters_json`.  
**Почему нет:** Невозможно валидировать на уровне БД, сложнее делать join с справочниками для отображения имён, сложнее расширять.

**Альтернатива:** Отдельная таблица на каждый мультиселект-параметр.  
**Почему нет:** 14+ таблиц для одного агрегата — избыточная сложность. Единая `filter_preset_values` с discriminator `parameter_name` проще и масштабируется.

### 2. Привязка к HH user ID, а не к системному UUID

**Решение:** `filter_presets.hh_user_id: str` — внешний идентификатор пользователя HH, получаемый из profile-service. Не FK к таблице пользователей main-be.

**Причина:** Фильтры не удаляются при удалении пользователя из системы (требование ТЗ). HH user ID стабилен и доступен через profile-service. При удалении системного пользователя фильтры остаются привязанными к HH аккаунту.

### 3. Vacancy-service запрашивает HH user ID через main-be → profile-service chain

**Решение:** При создании/обновлении пресета vacancy-service получает `X-User-Id` (системный UUID) из заголовка и делает HTTP-запрос к profile-service для получения selected HH account (hh_user_id). Это делает vacancy-service owner данных фильтров без прямого доступа к БД profile-service.

**Альтернатива:** Передавать hh_user_id напрямую от main-be в отдельном заголовке.  
**Почему нет:** Нарушает принцип single source of truth — vacancy-service должен сам верифицировать привязку. Но для простоты в первой итерации main-be передаёт `X-Hh-User-Id` заголовок, а vacancy-service доверяет ему (закрытая сеть, internal API).

**Конечное решение:** main-be передаёт `X-User-Id` (системный UUID) и `X-Hh-User-Id` (строка) в vacancy-service. Vacancy-service использует `X-Hh-User-Id` для привязки фильтров. Это избегает лишнего HTTP- roundtrip к profile-service при каждом запросе фильтров.

### 4. API endpoints в vacancy-service


| Метод    | Path                            | Описание                                       |
| -------- | ------------------------------- | ---------------------------------------------- |
| `GET`    | `/internal/filters`             | LIST пресетов пользователя (только имена + id) |
| `GET`    | `/internal/filters/{preset_id}` | GET полного пресета со всеми значениями        |
| `POST`   | `/internal/filters`             | Создание пресета                               |
| `PATCH`  | `/internal/filters/{preset_id}` | Обновление пресета (имя + значения)            |
| `DELETE` | `/internal/filters/{preset_id}` | Удаление пресета                               |


Все endpoints требуют `X-User-Id` (UUID) и `X-Hh-User-Id` (строка). LIST поддерживает `q` (поиск по имени), `limit`, `offset`, сортировку по `-created_at`.

### 5. Proxy endpoints в main-be


| Метод    | Path                       | Описание                                 |
| -------- | -------------------------- | ---------------------------------------- |
| `GET`    | `/api/filters`             | LIST пресетов (прокси к vacancy-service) |
| `GET`    | `/api/filters/{preset_id}` | GET пресета                              |
| `POST`   | `/api/filters`             | Создание пресета                         |
| `PATCH`  | `/api/filters/{preset_id}` | Обновление пресета                       |
| `DELETE` | `/api/filters/{preset_id}` | Удаление пресета                         |


main-be при каждом запросе к vacancy-service передаёт `X-User-Id` (из cookie-auth) и `X-Hh-User-Id` (запрашивает у profile-service по текущему selected account).

### 6. Передача X-Hh-User-Id от main-be

**Решение:** main-be при каждом proxy-запросе к vacancy-service для фильтров делает前置запрос к profile-service: `GET /internal/hh-accounts/selected` с `X-User-Id`, получает `hh_user_id` и передаёт его в `X-Hh-User-Id` заголовке.

**Альтернатива:** Vacancy-service сам обращается к profile-service.  
**Почему нет:** Дополнительный HTTP-запрос при каждом обращении к фильтрам. Main-be уже имеет связь с profile-service и знает selected account.

### 7. Валидация значений по справочникам

**Решение:** При создании и обновлении пресета vacancy-service MUST валидировать каждое значение мультиселект-параметра по соответствующему справочнику. Значение, отсутствующее в справочнике (active=true), MUST отклоняться с `422`.

**Альтернатива:** Сохранять значения без валидации, проверять только при применении фильтров.  
**Почему нет:** Пользователь может сохранить несуществующие значения, которые потом не будут работать. Ранняя валидация даёт немедленную обратную связь.

**Реализация:** В репозитории/сервисе фильтров при сохранении значений выполняется SELECT из соответствующей таблицы справочника по `hh_id`. Для `area` — таблица `areas`, для `professional_role` — `professional_roles`, для `industry` — `industries`, для `metro` — `metro_stations`, для `language` — `languages`. Для значений из HH-дictionaries (`experience`, `label`, `employment_form`, `work_format`, `work_schedule_by_days`, `working_hours`, `education`, `salary_frequency`, `driver_license_types`, `search_field`) — проверка по `dictionary_items` с соответствующим `dictionary_code`.

**На фронтенде:** Поля-справочники в форме MUST использовать только Select/MultiSelect с закрытым списком (без возможности свободного ввода). Пользователь выбирает только из значений, загруженных из API справочников.

### 8. Фронтенд: Drawer слева вместо сверху

**Решение:** Drawer с `anchor="left"` для области фильтров, в отличие от AccountsDrawer (`anchor="top"`). Причина: фильтров много, левый Drawer даёт больше вертикального пространства и привычную UX-паттерн для панели настроек.

## Risks / Trade-offs


| Риск                                                                  | Митигация                                                                                     |
| --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Лишний HTTP-запрос к profile-service при каждом proxy-вызове фильтров | Кешировать hh_user_id в контексте запроса; в будущем — JWT claim                              |
| `filter_preset_values` может расти при большом количества пресетов    | Индексы на `(preset_id, parameter_name)`; каскадное удаление                                  |
| Несоответствие справочников HH и доступных значений фильтров          | Валидация значений по справочникам обязательна при сохранении; на фронтенде — только выбор из закрытого списка |
| Форма фильтров содержит 20+ полей — сложный UI                        | Группировка по категориям (текст, местоположение, профессия, условия работы, зарплата, метки) |




## Migration Plan

1. Alembic migration: создание `filter_presets` и `filter_preset_values`.
2. Деплой vacancy-service с новыми endpoints.
3. Деплой main-be с proxy-роутами.
4. Деплой main-fe с Drawer.
5. Откат: миграция down (drop таблиц), удаление router файлов.



