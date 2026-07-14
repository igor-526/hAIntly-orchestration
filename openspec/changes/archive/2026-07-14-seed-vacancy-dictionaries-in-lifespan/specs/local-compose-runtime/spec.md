## MODIFIED Requirements

### Requirement: Изолированные процессы Celery vacancy-service
Compose project `haintly-vacancy-service` MUST запускать Celery worker и Celery Beat как отдельные процессы `vacancy-service`, использующие общий Redis из инфраструктурного compose через валидируемое окружение. Compose сервиса MUST содержать приложение и миграции, но MUST NOT создавать собственные PostgreSQL или Redis. App MUST в FastAPI lifespan до readiness быстро и локально сидировать семь фиксированных `dictionary_sync_states`; startup seed MUST зависеть только от собственной актуальной PostgreSQL schema и MUST NOT обращаться к HH API, Redis или Celery.

#### Scenario: Запуск vacancy-service
- **WHEN** пользователь запускает compose `vacancy-service` с применёнными migrations и доступными инфраструктурными PostgreSQL и Redis
- **THEN** приложение создаёт или проверяет семь фиксированных sync states, после чего app, worker и Beat работают в проекте `haintly-vacancy-service`, а приложение проходит healthcheck на опубликованном порту `8103`

#### Scenario: Redis URL отсутствует
- **WHEN** обязательная Celery/Redis конфигурация отсутствует или невалидна
- **THEN** worker и Beat завершают запуск конфигурационной ошибкой вместо использования hardcoded broker, при этом lifespan app не использует Redis для DB seed

#### Scenario: Ошибка startup seed
- **WHEN** PostgreSQL недоступна, schema устарела либо существующие UUID/name противоречат seed definition
- **THEN** app завершается до readiness с диагностируемой ошибкой, а healthcheck не сообщает ложную готовность

#### Scenario: Внешняя сеть недоступна
- **WHEN** PostgreSQL и schema готовы, но HH API недоступен во время запуска app
- **THEN** lifespan seed не ждёт сеть, приложение проходит startup и фоновая синхронизация обрабатывает доступность HH независимо
