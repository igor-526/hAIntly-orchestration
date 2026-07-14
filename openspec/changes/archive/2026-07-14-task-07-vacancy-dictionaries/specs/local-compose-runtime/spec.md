## ADDED Requirements

### Requirement: Изолированные процессы Celery vacancy-service
Compose project `haintly-vacancy-service` MUST запускать Celery worker и Celery Beat как отдельные процессы `vacancy-service`, использующие общий Redis из инфраструктурного compose через валидируемое окружение. Compose сервиса MUST содержать приложение и миграции, но MUST NOT создавать собственные PostgreSQL или Redis.

#### Scenario: Запуск vacancy-service
- **WHEN** пользователь запускает compose `vacancy-service` с доступными инфраструктурными PostgreSQL и Redis
- **THEN** приложение, миграции, worker и Beat запускаются в проекте `haintly-vacancy-service`, а приложение проходит healthcheck на опубликованном порту `8103`

#### Scenario: Redis URL отсутствует
- **WHEN** обязательная Celery/Redis конфигурация отсутствует или невалидна
- **THEN** worker и Beat завершают запуск конфигурационной ошибкой вместо использования hardcoded broker

### Requirement: Полный Makefile-пайплайн vacancy-service
Корневой Makefile MUST предоставлять `vacancy` для запуска compose и `vacancy-build` только для сборки образов без запуска, а Makefile `vacancy-service` MUST предоставлять `lint`, `format` и `test` для полного применимого пайплайна сервиса.

#### Scenario: Сборка без запуска
- **WHEN** пользователь выполняет `make vacancy-build`
- **THEN** образы `vacancy-service` собираются без запуска app, migration, worker или Beat

#### Scenario: Проверка сервиса
- **WHEN** исполнитель запускает `lint`, `format` и `test` из Makefile сервиса
- **THEN** выполняются все настроенные статические, форматирующие и тестовые проверки `vacancy-service`
