## Context

Change `task-12-github-testing` разделил тесты `vacancy-service` на автономный `make test` и локальный `make test-infra`. Однако pytest загружает корневой `tests/conftest.py` до применения marker-фильтра. Этот файл импортирует `settings`, а модуль `src/settings.py` немедленно создаёт глобальный `Settings()`. В GitHub Actions сервисный `.env` отсутствует, поэтому восемь обязательных полей приводят к `ValidationError` ещё до collection и исключения infrastructure-тестов.

Поля действительно обязательны для runtime: HH adapter, Celery, Redis lock и исходящий HTTP-клиент `profile-service` не должны получать production defaults. Проблема находится на тестовой границе и не требует менять владельцев данных, сервисные потоки или runtime-контракт.

## Goals / Non-Goals

**Goals:**

- обеспечить import/collection и выполнение автономного pytest-набора `vacancy-service` без `.env`, repository secrets, Docker, PostgreSQL и Redis;
- сохранить один и тот же `make test` локально и в GitHub Actions;
- предоставить модулям, импортируемым автономными тестами, валидную, детерминированную и безопасную test-конфигурацию;
- позволить `make test-infra` переопределять test defaults реальными локальными адресами и credentials;
- сохранить строгую fail-fast валидацию `Settings` при обычном runtime-запуске сервиса.

**Non-Goals:**

- добавление defaults обязательным runtime-полям в `src/settings.py`;
- изменение GitHub Actions workflow или добавление service containers/secrets;
- изменение API, HTTP-потоков, `X-User-Id`, service auth, БД, миграций, Celery-задач, Redis locking или событий NATS JetStream;
- реальные обращения автономных тестов к HH, `profile-service` или иной внешней системе;
- пересмотр marker-классификации, не связанный с обнаруженной ошибкой collection.

## Decisions

### 1. Test-конфигурация устанавливается до импорта application settings

Корневой `tests/conftest.py` до любых импортов из `src` устанавливает отсутствующие обязательные переменные через `os.environ.setdefault`. Набор включает только значения, без которых глобальный `Settings()` не валидируется:

- фиктивный HH application token достаточной длины;
- URL на зарезервированном домене `.invalid` и test user-agent;
- локальные Redis DSN для Celery broker/backend и dictionary lock;
- положительный возраст словарей;
- URL `profile-service` на `.invalid`.

`setdefault` принципиален: `scripts/test.sh` сначала загружает локальную infrastructure-конфигурацию, и её реальные значения не перезаписываются test defaults.

Альтернатива — передавать env непосредственно в Makefile — отклонена: импорт тестов через IDE или прямой `uv run pytest` снова зависит от внешней подготовки, а тестовая граница остаётся не самодостаточной.

### 2. Runtime `Settings` не получает test-aware ветвление и небезопасные defaults

`src/settings.py` продолжает требовать адреса, credentials и интеграционные параметры из валидируемого окружения. Production-код не распознаёт pytest, `ENVIRONMENT=test`, `CI` или `GITHUB_ACTIONS` и не подставляет фиктивные адреса самостоятельно.

Альтернатива — добавить defaults в модель `Settings` — отклонена, потому что опечатка или пропущенная runtime-переменная сможет незаметно направить приложение на тестовый адрес вместо fail-fast ошибки при старте.

### 3. Test defaults не являются разрешением на внешние обращения

Автономные тесты обязаны заменять repository/client/lifespan зависимости либо тестировать чистую логику. Фиктивные DSN и URL нужны только для построения конфигурации и импортов; попытка соединения остаётся ошибкой теста и сигналом неверной классификации. Тест, которому действительно нужны PostgreSQL, Redis, другой сервис, провайдер или secret, сохраняет marker `infrastructure`.

### 4. Регрессия проверяется в очищенном subprocess

Добавляется проверка, запускающая автономный pytest entry point или минимальный collection/import probe в дочернем процессе с удалёнными обязательными runtime-переменными и без доступного сервисного `.env`. Проверка должна доказать, что конфигурацию предоставляет сам test harness, а не окружение рабочей машины.

Проверка не должна рекурсивно запускать саму себя и не должна обращаться к сети. Допустим отдельный небольшой smoke script/test, если это делает границу запуска явной.

Альтернатива — считать обычный локальный `make test` достаточным — отклонена: tracked локальный `.env` маскирует исходную ошибку GitHub Actions.

### 5. Архитектурные потоки не меняются

- **HTTP:** `vacancy-service` по-прежнему является вызывающей стороной `profile-service`; адрес валидируется из runtime environment, `X-User-Id` и service credential этим change не затрагиваются.
- **HeadHunter:** существующий HH adapter и параметры локальной OpenAPI-интеграции не меняются; test URL не используется для реального вызова, поэтому новый endpoint или контракт HH не вводится.
- **БД и Redis:** владельцем vacancy data остаётся `vacancy-service`; test defaults не создают соединений, а `make test-infra` использует локальные credentials из `.docker-compose/.env`.
- **Celery и NATS JetStream:** задачи, broker/backend и события не меняются.
- **Безопасность и персональные данные:** test values не являются secrets, не содержат пользовательских данных и не выводят реальные credentials; runtime secrets остаются обязательными.

## Risks / Trade-offs

- [Автономный тест случайно выполнит реальное соединение по test DSN] → Использовать недоступные/зарезервированные test endpoints, сохранять mock/fake зависимости и проверять marker-классификацию в Quality Gate.
- [Локальный `.env` продолжит маскировать регрессию] → Выполнить отдельную проверку в очищенном окружении или временном checkout без `.env`.
- [Test defaults перезапишут infrastructure credentials] → Использовать только `setdefault` и проверить `make test-infra` с загруженным `.docker-compose/.env`.
- [Глобальная мутация environment повлияет на тесты `Settings`] → Ограничить значения обязательными полями и в тестах валидации явно управлять env через `monkeypatch`; проверить весь автономный набор.
- [Решение будет скопировано в production-код] → Зафиксировать test-only расположение и запрет runtime defaults в delta spec и review checklist.

## Migration Plan

1. Добавить раннюю test-конфигурацию и регрессионную проверку в `vacancy-service`.
2. Запустить автономный pipeline без сервисного `.env` и обязательных runtime-переменных.
3. Запустить обычные `make format`, `make lint`, `make test`.
4. При доступной локальной инфраструктуре выполнить `make test-infra`, убедившись, что реальные значения окружения имеют приоритет.
5. Пересобрать и поднять изменённый контейнер только если затронут runtime/container context; при test-only изменении подтвердить отсутствие необходимости runtime rebuild.

Rollback состоит в удалении test-only defaults и регрессионной проверки; production deployment и данные миграции не требуют.

## Open Questions

Нет.
