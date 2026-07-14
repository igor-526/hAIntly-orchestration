## ADDED Requirements

### Requirement: Управляемый rebuild справочников vacancy-service
Проект MUST предоставлять документированный и автоматизируемый порядок rebuild справочников `vacancy-service`: остановка процессов записи, destructive reset только явно подтверждённой local/test БД сервиса, `alembic upgrade head`, отдельный seed, DB/runtime-проверки и запуск сервисных процессов. Обычный production startup, migration container и `alembic upgrade head` MUST NOT автоматически выполнять DROP или reset данных.

#### Scenario: Полный local/test rebuild
- **WHEN** оператор явно запускает rebuild для подтверждённой local/test БД `vacancy-service`
- **THEN** операции выполняются в порядке reset → upgrade до head → seed до terminal success → DB/runtime-проверки и не затрагивают БД других сервисов

#### Scenario: Попытка destructive reset production
- **WHEN** reset-команда обнаруживает production или production-like окружение либо не получает явного local/test подтверждения
- **THEN** она завершается ошибкой до DROP и предлагает использовать недеструктивный upgrade и отдельно контролируемый seed

#### Scenario: Обычный production deployment
- **WHEN** запускаются production migration/application процессы
- **THEN** они не выполняют автоматический reset, а seed остаётся отдельной явно запускаемой операцией

### Requirement: Проверяемая UUID-схема после rebuild
После чистого upgrade схема `vacancy-service` MUST содержать UUID primary key во всех таблицах справочников и в `dictionary_sync_states`, уникальное `dictionary_sync_states.name`, действующие domain unique constraints/FK и Alembic revision head.

#### Scenario: Проверка чистой схемы
- **WHEN** local/test reset и `alembic upgrade head` завершены
- **THEN** автоматическая проверка подтверждает UUID PK, ограничения и `alembic current=head` до запуска seed

#### Scenario: Проверка данных после seed
- **WHEN** seed достиг terminal success
- **THEN** DB-проверка подтверждает семь уникальных sync states с UUID, отсутствие дублей domain keys и непустые ожидаемые таблицы снимков
