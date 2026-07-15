## 1. Backend

### vacancy-service

- [x] 1.1 Создать модели `FilterPreset` и `FilterPresetValue` в `src/models/filter_presets.py` с нормализованными колонками и relationships
- [x] 1.2 Создать Pydantic-схемы (request/response) для CRUD фильтров в `src/core/schemas/filters.py`
- [x] 1.3 Создать Alembic-миграцию для таблиц `filter_presets` и `filter_preset_values` с индексами
- [x] 1.4 Создать репозиторий `src/repositories/filters.py` с CRUD-операциями, cascade delete и валидацией значений по справочникам
- [x] 1.5 Создать router `src/api/filters.py` с endpoints GET (LIST), GET (detail), POST, PATCH, DELETE в namespace `/internal/filters`
- [x] 1.6 Добавить валидацию заголовков `X-User-Id` и `X-Hh-User-Id` в dependency для endpoints фильтров
- [x] 1.7 Подключить router в `src/main.py`
- [x] 1.8 Написать unit-тесты для репозитория фильтров
- [x] 1.9 Написать интеграционные тесты для API фильтров (CRUD, валидация, пагинация, поиск, изоляция пользователей, валидация значений по справочникам)
- [x] 1.10 Собрать образ vacancy-service, поднять контейнеры, проверить health и логи

### main-be

- [x] 1.11 Расширить `VacancyServiceClient` в `src/infrastructure/vacancy_service.py` методами CRUD для фильтров
- [x] 1.12 Добавить метод получения `hh_user_id` из profile-service (selected HH account) в `ProfileServiceClient` или создать отдельный helper
- [x] 1.13 Создать router `src/api/filters.py` с proxy-endpoints GET, GET/{id}, POST, PATCH, DELETE в namespace `/api/filters`
- [x] 1.14 Подключить router в `src/main.py`
- [x] 1.15 Написать тесты для proxy-endpoints фильтров
- [x] 1.16 Собрать образ main-be, поднять контейнеры, проверить health и логи

## 2. Frontend

### main-fe

- [x] 2.1 Создать `features/filters/types.ts` с TypeScript-типами для пресетов и значений фильтров
- [x] 2.2 Создать `features/filters/service.ts` с методами list, get, create, update, remove через `apiRequest()`
- [x] 2.3 Создать `features/filters/use-filters.ts` хук с состоянием формы, загрузкой пресетов и CRUD-операциями
- [x] 2.4 Создать `features/filters/filter-drawer.tsx` — Drawer с формой фильтров, селектором пресетов и кнопками
- [x] 2.5 Создать `features/filters/preset-selector.tsx` — выпадающее меню пресетов с поиском и управлением (edit/delete)
- [x] 2.6 Создать `features/filters/filter-form.tsx` — форма со всеми не-deprecated полями фильтров, сгруппированными по категориям; справочные поля — только закрытые Select/MultiSelect без свободного ввода
- [x] 2.7 Создать `features/filters/preset-modal.tsx` — модальное окно для создания/переименования пресета
- [x] 2.8 Создать `features/filters/delete-confirm-modal.tsx` — модальное окно подтверждения удаления
- [x] 2.9 Интегрировать FilterDrawer в `features/hh-accounts/workspace.tsx` вместо disabled кнопки
- [x] 2.10 Написать тесты для filter service, use-filters хука и ключевых компонентов
- [x] 2.11 Запустить dev-server, проверить Drawer, форму, CRUD пресетов в браузере

## 3. Quality Gate

- [x] 3.1 Проверить соответствие реализации спецификациям `filter-preset-storage`, `filter-preset-proxy`, `filter-preset-ui` — FIX: refresh(preset) после flush, min_length=1 на name
- [x] 3.2 Проверить smoke API фильтров напрямую к vacancy-service — FIX: PATCH возвращает 200, updated_at обновляется
- [x] 3.3 Проверить proxy smoke API фильтров через main-be — FIX: пересборка образа устранила NameError
- [x] 3.4 Проверить e2e: создать пресет, получить, обновить имя, обновить значения, удалить — FIX: PATCH работает, пустое имя отклоняется
- [x] 3.5 Проверить валидацию: попытка сохранить пресет с несуществующим значением справочника возвращает 422
- [x] 3.6 Проверить изоляцию пользователей: пользователь A не видит пресеты пользователя B
- [x] 3.7 Проверить frontend: Drawer открывается/закрывается, форма заполняется, пресеты сохраняются/загружаются/удаляются — code review + 89 тестов passed
- [x] 3.8 Проверить frontend: справочные поля допускают только выбор из списка, свободный ввод заблокирован — freeSolo не используется
- [x] 3.9 Проверить логи всех затронутых контейнеров на наличие ошибок — FIX: MissingGreenlet и NameError устранены
- [x] 3.10 Создать отчёт в `docs/reports` по `docs/reports/TEMPLATE.md`
