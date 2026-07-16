## 1. Backend

### main-be

- [x] 1.1 Зарегистрировать strict pytest marker `infrastructure` и разделить Makefile-команды так, чтобы `make test` запускал автономный набор, а `make test-infra` — только infrastructure-тесты.
- [x] 1.2 Классифицировать межсервисный smoke `test_profile_service_smoke.py` как infrastructure-тест и заменить неявное ожидание соседнего checkout/`.venv` на валидируемую локальную конфигурацию с конкретной диагностикой отсутствующей зависимости.
- [x] 1.3 Добавить или скорректировать тесты командного контракта так, чтобы автономный набор подтверждал работу без каталога `profile-service`, а infrastructure-набор сохранял проверку реального HTTP-потока `main-be` → `profile-service`.
- [x] 1.4 Выполнить `make format`, `make lint`, `make test` без соседнего `profile-service`, затем локально выполнить `make test-infra` с подготовленной зависимостью и зафиксировать результаты.
- [x] 1.5 Пересобрать образ через `make be-build`, поднять `make be`, проверить health и изучить логи изменённого контейнера `main-be`.

### vacancy-service

- [x] 1.6 Зарегистрировать strict pytest marker `infrastructure` и пометить им PostgreSQL-, Redis-, migration- и зависящие от реальной БД seeding-тесты, сохранив автономные API/unit/in-process integration-тесты в CI-наборе.
- [x] 1.7 Разделить Makefile и `scripts/test.sh`: `make test` не должен проверять Docker или HAIntly infrastructure, а `make test-infra` должен выполнять preflight PostgreSQL/Redis, безопасно загружать локальное окружение и запускать все infrastructure-тесты без молчаливых skip.
- [x] 1.8 Добавить или скорректировать тесты/проверки маршрутизации наборов, подтверждающие автономный запуск без контейнеров и полный локальный запуск repository, Redis lock, migration и seeding-сценариев.
- [x] 1.9 Выполнить `make format`, `make lint`, `make test` без PostgreSQL/Redis, затем поднять `make infra`, выполнить `make test-infra` и зафиксировать результаты без раскрытия credentials.
- [x] 1.10 Пересобрать образ через `make vacancy-build`, поднять `make vacancy`, проверить health и изучить логи изменённых контейнеров `vacancy-service`.

### profile-service

- [x] 1.11 Проверить весь pytest-набор на зависимости от Docker, внешних сервисов, соседних checkout и secrets, зарегистрировать strict marker `infrastructure`, добавить `make test-infra` и при обнаружении зависимых тестов классифицировать их с проверяемым покрытием разделения.
- [x] 1.12 Выполнить `make format`, `make lint`, `make test`, `make test-infra`; если сервис был изменён, также выполнить `make profile-build`, поднять `make profile`, проверить health и логи.

### ai-service

- [x] 1.13 Проверить весь pytest-набор на зависимости от Docker, OpenRouter/других внешних провайдеров, соседних checkout и secrets, зарегистрировать strict marker `infrastructure`, добавить `make test-infra` и при обнаружении зависимых тестов классифицировать их с проверяемым покрытием разделения.
- [x] 1.14 Выполнить `make format`, `make lint`, `make test`, `make test-infra`; если сервис был изменён, также выполнить `make ai-build`, поднять `make ai`, проверить health и логи.

### fastapi_template

- [x] 1.15 Обновить шаблонные Makefile и pytest-конфигурацию: `make test` запускает автономный набор, strict marker `infrastructure` зарегистрирован, а исполняемый `make test-infra` готов для будущих infrastructure-тестов без создания фиктивных тестов.
- [x] 1.16 Добавить проверяемое покрытие шаблонного командного контракта, включая успешное и понятное поведение `make test-infra` при отсутствии infrastructure-тестов.
- [x] 1.17 Выполнить в `fastapi_template` полный применимый pipeline `make format`, `make lint`, `make test`, `make test-infra` и проверить, что скопированный шаблон не требует HAIntly infrastructure для автономного набора.

### workflow

- [x] 1.18 Обновить `AGENTS.md`: закрепить наследование `make test`/`infrastructure`/`make test-infra` из `fastapi_template` каждым новым backend-сервисом и обязательную классификацию каждого нового backend-теста при создании.
- [x] 1.19 Обновить `agents/backend.md`: обязать Backend Agent классифицировать каждый добавляемый или изменяемый pytest-тест по фактическим зависимостям и запускать `make test-infra` для затронутого сервиса отдельно от `make test`.
- [x] 1.20 Обновить `agents/quality_gate.md`: обязать reviewer проверять классификацию каждого добавленного или изменённого backend-теста, автономность `make test` и полноту отдельного `make test-infra`.

## 2. Frontend

### main-fe

- [x] 2.1 Подтвердить, что Vitest-набор `main-fe` и `make test` работают после установки зависимостей без backend, browser e2e infrastructure и secrets; при обнаружении зависимости отделить её от автономного CI-набора без введения pytest-контракта.
- [x] 2.2 Выполнить `make format`, `make lint`, `make test` и `make build`; если frontend был изменён, также выполнить `make fe-build`, поднять `make fe`, проверить доступность приложения и изучить логи контейнера.
- [x] 2.3 Обновить tracked `tsconfig.json` так, чтобы штатный `npm run build` не дописывал `.next/types/**/*.ts` и `.next/dev/types/**/*.ts` и не изменял рабочее дерево.
- [x] 2.4 Повторить `make format`, `make lint`, `make test` и `make build` из чистого дерева, проверить отсутствие изменений tracked-файлов и удалить generated build artifacts перед передачей.

## 3. Quality Gate

- [x] 3.1 Отдельно проверить diff и соответствие proposal, design, delta spec и checklist, включая отсутствие изменений продуктовых API, БД, событий, auth и сервисных границ.
- [x] 3.2 В чистом от HAIntly infrastructure окружении выполнить `make test` в `main-be`, `profile-service`, `vacancy-service`, `ai-service`, `main-fe` и `fastapi_template`, подтвердив отсутствие Docker, соседних checkout, внешних провайдеров и secrets.
- [x] 3.3 Независимо выполнить `make test-infra` во всех затронутых backend-проектах: при наличии infrastructure-тестов — с локально поднятыми зависимостями и без молчаливых skip, при их отсутствии — проверить штатное пустое поведение цели.
- [x] 3.4 Выполнить применимые `make format`, `make lint`, сборки образов без запуска, запуск изменённых контейнеров, health/runtime smoke и проверку логов; для `main-be` отдельно проверить локальный межсервисный smoke с `profile-service`.
- [x] 3.5 Проверить workflow реализованных сервисов: checkout одного репозитория, установка только его зависимостей и вызов автономного `make test` без добавления service containers; подтвердить, что падение автономного теста остаётся блокирующим.
- [x] 3.6 Проверить, что test credentials/service credentials берутся только из локального окружения или untracked env-файлов и не попали в diff, логи или отчёт.
- [x] 3.7 Проверить, что `fastapi_template`, `AGENTS.md`, `agents/backend.md` и `agents/quality_gate.md` согласованно закрепляют контракт для каждого будущего backend-сервиса и каждого нового или изменённого pytest-теста.
- [x] 3.8 После решения `ОДОБРЕНО` создать отчёт `docs/reports/task-12-github-testing.md` по `docs/reports/TEMPLATE.md`.
- [x] 3.9 После frontend-доработки повторить обязательную проверку чистоты дерева до/после `npm run build` и остальные применимые проверки Quality Gate.
