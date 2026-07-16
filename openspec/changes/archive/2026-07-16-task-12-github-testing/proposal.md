## Why

Текущий контракт `make test` смешивает автономные проверки с тестами, которым нужны соседние репозитории, Docker-контейнеры, PostgreSQL или Redis. Из-за этого тесты проходят в локальном монорепозитории, но штатные GitHub Actions отдельных сервисов завершаются ошибкой, хотя автономная часть кода исправна.

## What Changes

- Разделить тестовый pipeline backend-сервисов на автономный CI-набор и явно запускаемый infrastructure-набор.
- Сохранить `make test` единым обязательным Quality Gate, который не требует Docker, внешних сервисов, соседних checkout или локальных `.venv` других проектов и поэтому выполняется в GitHub Actions отдельного репозитория.
- Добавить отдельную Makefile-цель для полного локального запуска infrastructure-тестов с проверкой и понятной диагностикой необходимых PostgreSQL, Redis и межсервисных зависимостей.
- Классифицировать infrastructure-тесты явным pytest marker и исключать их из автономного набора по декларативной конфигурации, а не по наличию переменной GitHub Actions.
- Исправить `main-be`: межсервисный smoke с реальным `profile-service` оставить локальной infrastructure-проверкой, не зависящей от несуществующего соседнего checkout при `make test`.
- Исправить `vacancy-service`: автономные API/unit-тесты запускать без предварительного `make infra`, а PostgreSQL-, Redis- и migration-тесты выполнять только в полном локальном infrastructure-наборе.
- Проверить и привести к тому же backend-контракту `profile-service`, `ai-service` и `fastapi_template`; `main-fe` сохранить в scope проверки как сервис без pytest-контракта.
- Закрепить этот контракт как обязательный для каждого будущего backend-микросервиса: новый FastAPI-сервис наследует автономный `make test`, strict marker `infrastructure` и готовую цель `make test-infra` из `fastapi_template`.
- Обязать разработчика классифицировать каждый новый backend-тест при его создании по фактическим зависимостям, а Quality Gate — проверять корректность классификации и маршрутизации теста.
- Обновить workflow-документы `AGENTS.md`, `agents/backend.md` и `agents/quality_gate.md`, чтобы правило сохранялось после архивирования change и применялось в последующей разработке.
- Не изменять продуктовые API, схемы БД, события NATS JetStream, пользовательское поведение и deployment-процесс.
- Не добавлять GitHub Actions service containers: инфраструктурные проверки остаются локальным полным набором, а CI запускает воспроизводимый автономный набор.
- `notification-service` не изменяется: в репозитории присутствует только placeholder README без реализованного тестового pipeline.

## Capabilities

### New Capabilities

Нет.

### Modified Capabilities

- `service-quality-commands`: уточняется обязательный контракт `make test`, вводится отдельный полный infrastructure-набор и единая классификация тестов, зависимых от локальной инфраструктуры или других сервисов.

## Impact

- `main-be`: Makefile/pytest-конфигурация и межсервисный smoke-тест `profile-service`.
- `vacancy-service`: Makefile, `scripts/test.sh`, pytest-конфигурация и integration-тесты PostgreSQL, Redis, миграций и seeding.
- `profile-service`, `ai-service`, `fastapi_template`: аудит и унификация Makefile/pytest-контракта без создания фиктивных infrastructure-тестов.
- Будущие backend-микросервисы: наследование тестового контракта из `fastapi_template` при создании.
- `AGENTS.md`, `agents/backend.md`, `agents/quality_gate.md`: нормативное закрепление классификации каждого нового теста и проверки этой классификации.
- `main-fe`: подтверждение, что существующий `make test` остаётся автономным и совместимым с GitHub Actions.
- GitHub Actions затронутых сервисов продолжают вызывать `make test`; изменение workflow требуется только при выявленном расхождении с единым контрактом.
- Новые runtime-зависимости, сетевые контракты и изменения владения данными отсутствуют.
