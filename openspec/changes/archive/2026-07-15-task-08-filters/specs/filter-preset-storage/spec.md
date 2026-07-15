## Purpose

Определить нормализованное хранение и CRUD-контракт пресетов фильтров вакансий в `vacancy-service`.

## ADDED Requirements

### Requirement: Нормализованная модель пресета фильтров
`vacancy-service` MUST хранить пресеты фильтров в таблице `filter_presets` с нормализованными скалярными колонками для каждого не-deprecated query-параметра `GET /vacancies`. Мультиселект-параметры MUST храниться в дочерней таблице `filter_preset_values` с discriminator `parameter_name`. Пресет MUST быть привязан к `hh_user_id` (строка) и MUST NOT удаляться при удалении системного пользователя.

#### Scenario: Создание пресета со скалярными и мультиселект-полями
- **WHEN** запрос на создание содержит `name`, `text`, `salary=100000` и `area=["1", "2"]`
- **THEN** в `filter_presets` создаётся запись с `name`, `text`, `salary=100000`, а в `filter_preset_values` — две записи с `parameter_name="area"` и `value="1"`, `value="2"`

#### Scenario: Пресет привязан к HH user ID
- **WHEN** пресет создан пользователем с `hh_user_id="12345"`
- **THEN** пресет содержит `hh_user_id="12345"` и доступен только этому пользователю

#### Scenario: Удаление системного пользователя не удаляет пресет
- **WHEN** системный пользователь удалён из HAIntly
- **THEN** его пресеты фильтров остаются в БД и доступны по `hh_user_id`

### Requirement: Скалярные колонки пресета
Таблица `filter_presets` MUST содержать следующие колонки для скалярных параметров: `id` (UUID PK), `hh_user_id` (str, NOT NULL), `name` (str, max 63, NOT NULL), `text` (str, nullable), `excluded_text` (str, nullable), `salary` (int, nullable), `currency` (str, nullable), `salary_mode` (str, nullable), `period` (int, nullable), `date_from` (str, nullable), `date_to` (str, nullable), `order_by` (str, nullable), `premium` (bool, nullable), `accept_temporary` (bool, nullable), `no_magic` (bool, nullable), `top_lat` / `bottom_lat` / `left_lng` / `right_lng` (float, nullable), `sort_point_lat` / `sort_point_lng` (float, nullable). Колонки `created_at` и `updated_at` MUST заполняться автоматически.

#### Scenario: Все скалярные параметры сохраняются
- **WHEN** запрос содержит `salary=150000`, `currency="RUR"`, `period=7`, `order_by="salary_desc"`
- **THEN** пресет сохраняет все указанные значения в соответствующих колонках

#### Scenario: Nullable-поля остаются NULL при отсутствии
- **WHEN** запрос не содержит `salary`
- **THEN** колонка `salary` в пресете равна `NULL`

### Requirement: Мультиселект-параметры в filter_preset_values
Таблица `filter_preset_values` MUST содержать: `id` (UUID PK), `preset_id` (FK → `filter_presets.id`, CASCADE DELETE), `parameter_name` (str, NOT NULL), `value` (str, NOT NULL). Уникальный constraint на `(preset_id, parameter_name, value)`. Допустимые `parameter_name`: `area`, `professional_role`, `industry`, `metro`, `label`, `experience`, `employment_form`, `work_format`, `work_schedule_by_days`, `working_hours`, `education`, `salary_frequency`, `driver_license_types`, `search_field`, `employer_id`.

#### Scenario: Мультиселект сохраняется как отдельные записи
- **WHEN** запрос содержит `experience=["noExperience", "between1And3"]`
- **THEN** создаются две записи в `filter_preset_values` с `parameter_name="experience"` и значениями `"noExperience"` и `"between1And3"`

#### Scenario: Обновление пресета заменяет мультиселект-значения
- **WHEN** PATCH обновляет `experience` с `["noExperience"]` на `["between3And6", "moreThan6"]`
- **THEN** старые записи `experience` удаляются, новые создаются

#### Scenario: Удаление пресета каскадно удаляет значения
- **WHEN** пресет удалён
- **THEN** все связанные `filter_preset_values` удалены автоматически

### Requirement: CRUD internal API пресетов
`vacancy-service` MUST предоставлять endpoints: `GET /internal/filters` (LIST), `GET /internal/filters/{preset_id}` (GET), `POST /internal/filters` (CREATE), `PATCH /internal/filters/{preset_id}` (UPDATE), `DELETE /internal/filters/{preset_id}` (DELETE). Все endpoints MUST требовать `X-User-Id` (UUID) и `X-Hh-User-Id` (строка) заголовки.

#### Scenario: LIST возвращает только имена и id
- **WHEN** авторизованный internal клиент запрашивает `GET /internal/filters`
- **THEN** возвращается список объектов с `id` и `name`, отсортированный по `-created_at`

#### Scenario: GET возвращает полный пресет со значениями
- **WHEN** авторизованный internal клиент запрашивает `GET /internal/filters/{preset_id}`
- **THEN** возвращается пресет со всеми скалярными полями и массивом `values` (каждый элемент — `{parameter_name, value}`)

#### Scenario: LIST поддерживает поиск по имени
- **WHEN** запрос `GET /internal/filters?q=москва`
- **THEN** возвращаются пресеты, содержащие «москва» в имени (case-insensitive)

#### Scenario: LIST с пагинацией
- **WHEN** запрос `GET /internal/filters?limit=10&offset=0`
- **THEN** возвращается не более 10 пресетов с указанным offset

#### Scenario: Создание пресета
- **WHEN** POST с валидным телом (name + параметры)
- **THEN** создаётся пресет, возвращается `201` с полным объектом

#### Scenario: Обновление пресета
- **WHEN** PATCH с частичным телом (только изменённые поля)
- **THEN** обновляются указанные поля, мультиселекты заменяются, возвращается `200` с обновлённым объектом

#### Scenario: Удаление пресета
- **WHEN** DELETE существующего пресета
- **THEN** пресет и все значения удалены, возвращается `204`

#### Scenario: Обращение к чужому пресету
- **WHEN** пользователь с `hh_user_id="111"` запрашивает пресет пользователя `hh_user_id="222"`
- **THEN** возвращается `404`

### Requirement: Валидация входных данных
Vacancy-service MUST валидировать: `name` — обязательное, max 63 символа; `parameter_name` — одно из допустимых значений; `value` — непустая строка; `preset_id` — валидный UUID. При невалидных данных MUST возвращаться `422` с описанием ошибки.

#### Scenario: Пустое имя пресета
- **WHEN** POST с `name=""`
- **THEN** возвращается `422` с сообщением об ошибке валидации

#### Scenario: Недопустимое имя параметра
- **WHEN** значение в `filter_preset_values` содержит `parameter_name="invalid_param"`
- **THEN** возвращается `422`

#### Scenario: Имя пресета длиннее 63 символов
- **WHEN** `name` содержит 64 символа
- **THEN** возвращается `422`

### Requirement: Валидация значений по справочникам
При создании и обновлении пресета vacancy-service MUST валидировать каждое значение мультиселект-параметра и каждый допустимый `value` скалярного справочного поля по соответствующему активному элементу справочника. Значение, отсутствующее среди `active=true` записей справочника, MUST отклоняться с `422`.

Соответствие параметров и справочников:
- `area` → таблица `areas` по `hh_id`
- `professional_role` → таблица `professional_roles` по `hh_id`
- `industry` → таблица `industries` по `hh_id`
- `metro` → таблица `metro_stations` по `hh_id`
- `employer_id` → нет локального справочника, принимается любая строка
- `experience`, `label`, `employment_form`, `work_format`, `work_schedule_by_days`, `working_hours`, `education`, `salary_frequency`, `driver_license_types`, `search_field` → таблица `dictionary_items` по `dictionary_code` и `hh_id`

#### Scenario: Валидное значение справочника
- **WHEN** запрос содержит `area=["1"]` и в таблице `areas` существует активная запись с `hh_id="1"`
- **THEN** значение принимается

#### Scenario: Невалидное значение справочника
- **WHEN** запрос содержит `area=["999999"]` и в таблице `areas` нет активной записи с `hh_id="999999"`
- **THEN** возвращается `422` с указанием невалидного значения и параметра

#### Scenario: Неактивное значение справочника
- **WHEN** запрос содержит `area=["5"]` и запись с `hh_id="5"` существует, но `active=false`
- **THEN** возвращается `422`

#### Scenario: Множественные невалидные значения
- **WHEN** запрос содержит `area=["1", "999", "888"]` и из них валиден только `"1"`
- **THEN** возвращается `422` со списком всех невалидных значений (`"999"`, `"888"`)

### Requirement: Требования к заголовкам internal API
Vacancy-service MUST валидировать наличие `X-User-Id` (валидный UUID) и `X-Hh-User-Id` (непустая строка) для всех endpoints фильтров. Отсутствие или невалидность MUST возвращать `400`.

#### Scenario: Отсутствует X-Hh-User-Id
- **WHEN** запрос не содержит `X-Hh-User-Id`
- **THEN** возвращается `400`

#### Scenario: Невалидный X-User-Id
- **WHEN** `X-User-Id` не является UUID
- **THEN** возвращается `400`
