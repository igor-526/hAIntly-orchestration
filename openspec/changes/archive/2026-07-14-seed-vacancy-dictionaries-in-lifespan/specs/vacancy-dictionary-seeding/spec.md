## ADDED Requirements

### Requirement: Lifespan-сидирование реестра состояний
FastAPI lifespan `vacancy-service` MUST до `yield` вызвать общий async utility из `src/utils/seeding`, который в локальной PostgreSQL-транзакции обеспечивает наличие ровно семи канонических строк `dictionary_sync_states` для `dictionaries`, `areas`, `countries`, `professional_roles`, `industries`, `metro` и `languages`. Seed definition MUST содержать явный фиксированный UUID constant для каждого logical name. Utility MUST NOT обращаться к HH API, Redis, Celery или другим сервисам и MUST NOT загружать строки dictionary payload.

#### Scenario: Чистая мигрированная база
- **WHEN** приложение запускается после актуального `alembic upgrade head`, а строки состояний отсутствуют
- **THEN** lifespan создаёт семь строк с точными фиксированными парами UUID/name и только после commit переходит к `yield`

#### Scenario: HH недоступен при startup
- **WHEN** приложение запускается с недоступным HH API, но с доступной актуальной PostgreSQL
- **THEN** локальный seed завершается без сетевого запроса к HH и приложение может стать ready

#### Scenario: В lifespan не создаются элементы справочников
- **WHEN** lifespan seed успешно завершён в БД без загруженных HH snapshots
- **THEN** существуют только семь канонических sync states, а таблицы dictionary payload остаются для заполнения Celery/Beat или отдельным operational seed

### Requirement: Идемпотентность и согласованность фиксированных состояний
Lifespan seed MUST выполнять conflict-safe insert по уникальному `name`, MUST быть безопасным при повторном и конкурентном startup и MUST после insert проверить точное соответствие всех семи logical names ожидаемым фиксированным UUID. Существующий UUID для канонического name MUST NOT молча заменяться во время startup; отсутствие схемы, DB error, UUID/name conflict или неполное отображение MUST прерывать startup до readiness и откатывать текущую транзакцию.

#### Scenario: Повторный startup
- **WHEN** приложение повторно запускается с уже существующими семью каноническими парами
- **THEN** seed не создаёт дубликаты, не изменяет UUID или sync metadata и startup завершается успешно

#### Scenario: Конкурентный startup replicas
- **WHEN** несколько replicas одновременно выполняют lifespan seed одной БД
- **THEN** unique constraints и conflict-safe insert оставляют ровно семь канонических строк, а каждый успешно стартовавший replica подтверждает одинаковое отображение UUID/name

#### Scenario: UUID не соответствует logical name
- **WHEN** для канонического `name` уже существует иной UUID или ожидаемый UUID занят другой строкой
- **THEN** utility завершает startup диагностируемой consistency error без скрытой замены primary key и приложение не становится ready

#### Scenario: Таблица отсутствует
- **WHEN** lifespan выполняется до применения требуемой Alembic migration
- **THEN** startup завершается schema/DB error до readiness и utility не создаёт схему самостоятельно

## MODIFIED Requirements

### Requirement: Отдельный seed-процесс справочников
`vacancy-service` MUST сохранять отдельно вызываемую operational seed-команду, которая после применения Alembic-миграций запускает штатную типизированную HH-синхронизацию для `dictionaries`, `areas`, `countries`, `professional_roles`, `industries`, `metro` и `languages`. Operational seed MUST использовать канонические logical names заранее lifespan-сидированных `dictionary_sync_states`, конфигурируемый HH-адаптер и существующие транзакции/locks, MUST NOT дублировать fixed UUID mapping, содержать или читать закоммиченный production payload HH и MUST NOT выполнять сетевые запросы из Alembic schema migration или FastAPI lifespan.

#### Scenario: Operational seed после чистой миграции и startup seed
- **WHEN** оператор применил `alembic upgrade head` к пустой local/test БД, lifespan создал семь канонических sync states и оператор запускает operational seed с валидной конфигурацией
- **THEN** команда получает все семь снимков через штатный HH-адаптер и применяет их тем же типизированным sync-процессом, обновляя состояния по logical name без замены фиксированных UUID

#### Scenario: Миграции не применены
- **WHEN** operational seed или lifespan seed запускается на БД без требуемой schema revision или таблиц
- **THEN** процесс завершается диагностируемой schema-ошибкой и не пытается создавать схему самостоятельно

#### Scenario: В репозитории отсутствуют внешние данные
- **WHEN** проверяется реализация lifespan/operational seed и Alembic migrations
- **THEN** они не содержат статический полный JSON/YAML/SQL payload справочников HH, а migrations и lifespan не обращаются к HH API
