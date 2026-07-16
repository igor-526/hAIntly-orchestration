## 1. Backend

### main-be

- [x] 1.1 Проверить и доработать `main-be` Makefile и formatter-конфигурацию так, чтобы цели `format`, `lint`, `test` были phony, не маскировали ошибки и `make format` исключал `.github` и `.helm`.
- [x] 1.2 Добавить регрессионную проверку исключения `.github`/`.helm`, устранить нарушения кода и тестов `main-be`, затем подтвердить успешные `make format`, повторный `make format` без нового diff, `make lint` и `make test`.
- [x] 1.3 Выполнить `make be-build`, поднять `main-be` через `make be`, проверить состояние/healthcheck, опубликованный порт и отсутствие ошибок в логах пересобранных контейнеров.

### profile-service

- [x] 1.4 Проверить и доработать `profile-service` Makefile и formatter-конфигурацию так, чтобы цели `format`, `lint`, `test` были phony, не маскировали ошибки и `make format` исключал `.github` и `.helm`.
- [x] 1.5 Добавить регрессионную проверку исключения `.github`/`.helm`, устранить нарушения кода и тестов `profile-service`, затем подтвердить успешные `make format`, повторный `make format` без нового diff, `make lint` и `make test`.
- [x] 1.6 Выполнить `make profile-build`, поднять сервис через `make profile`, проверить состояние/healthcheck, опубликованный порт и отсутствие ошибок в логах пересобранных контейнеров приложения и миграций.

### vacancy-service

- [x] 1.7 Проверить и доработать `vacancy-service` Makefile и formatter-конфигурацию так, чтобы цели `format`, `lint`, `test` были phony, не маскировали ошибки и `make format` исключал `.github` и `.helm`.
- [x] 1.8 Добавить регрессионную проверку исключения `.github`/`.helm`, устранить нарушения кода и тестов `vacancy-service`, затем подтвердить успешные `make format`, повторный `make format` без нового diff, `make lint` и `make test`.
- [x] 1.9 Выполнить `make vacancy-build`, поднять сервис через `make vacancy`, проверить состояние/healthcheck, опубликованный порт и отсутствие ошибок в логах пересобранных контейнеров приложения и миграций.
- [x] 1.17 Восстановить оба integration-теста migration из `tests/integration/test_legacy_uuid_migration.py` и адаптировать их и тестовую migration infrastructure к текущей нормативной цепочке без удаления, skip или ослабления сценариев; повторить полный quality/runtime pipeline `vacancy-service`.

### ai-service

- [x] 1.10 Проверить и доработать `ai-service` Makefile и formatter-конфигурацию так, чтобы цели `format`, `lint`, `test` были phony, не маскировали ошибки и `make format` исключал `.github` и `.helm`.
- [x] 1.11 Добавить регрессионную проверку исключения `.github`/`.helm`, устранить нарушения кода и тестов `ai-service`, затем подтвердить успешные `make format`, повторный `make format` без нового diff, `make lint` и `make test`.
- [x] 1.12 Выполнить `make ai-build`, поднять сервис через `make ai`, проверить состояние/healthcheck, опубликованный порт и отсутствие ошибок в логах пересобранных контейнеров приложения и миграций.

### fastapi_template

- [x] 1.13 Доработать `fastapi_template` Makefile и formatter-конфигурацию до того же phony-контракта `format`/`lint`/`test` с исключением `.github` и `.helm` и регрессионной проверкой этих исключений.
- [x] 1.14 Устранить нарушения шаблона и подтвердить успешные `make format`, повторный `make format` без нового diff, `make lint` и `make test` без ослабления правил или пропуска тестов.

### agent-workflow

- [x] 1.15 Обновить `agents/backend.md`: непосредственно перед передачей требовать `make format`, `make lint`, `make test` в каждом затронутом backend-сервисе, фиксировать результаты и блокировать передачу при отсутствии, пропуске или ошибке команды, сохранив действующие build/runtime-проверки.
- [x] 1.16 Обновить `agents/quality_gate.md`: независимо запускать все три Makefile-команды в каждом затронутом сервисе, отражать результаты по сервисам и возвращать `НА ДОРАБОТКУ` при отсутствии, пропуске или ошибке любой команды.

## 2. Frontend

### main-fe

- [x] 2.1 Выбрать совместимый с текущим frontend stack formatter, добавить его в development-зависимости и lock-файл, настроить правила и исключения `.github`/`.helm` без глобальной зависимости.
- [x] 2.2 Реализовать phony-цели `format`, `lint`, `test` в `services/main-fe/Makefile`, сохранив полный lint/typecheck pipeline и корректное распространение кодов ошибок.
- [x] 2.3 Добавить регрессионную проверку исключения `.github`/`.helm`, устранить нарушения frontend-кода и тестов, затем подтвердить успешные `make format`, повторный `make format` без нового diff, `make lint` и `make test`.
- [x] 2.4 Обновить `agents/frontend.md`: непосредственно перед передачей требовать три Makefile-команды для каждого затронутого frontend-сервиса, фиксировать результаты и блокировать передачу при отсутствии, пропуске или ошибке команды, сохранив проверки артефактов и runtime.
- [x] 2.5 Выполнить `make fe-build`, поднять frontend через `make fe`, проверить состояние контейнера, опубликованный порт, существующий route, логи и отсутствие новых либо изменённых `.next`, `out`, `build`, `coverage`, cache и `*.tsbuildinfo` в рабочем дереве.

## 3. Quality Gate

- [x] 3.0 После Backend rework повторно проверить полный diff, обязательную matrix format/lint/test и runtime `vacancy-service`, включая оба восстановленных migration integration-теста.
- [x] 3.1 Проверить полный diff на соответствие proposal/design/spec, отсутствие изменений runtime-контрактов и отсутствие обходов проверок: ослабления правил, широких ignore, исключения исходников или пропуска тестов.
- [x] 3.2 Независимо выполнить `make format`, повторный `make format` с проверкой отсутствия нового diff, `make lint` и `make test` в `main-be`, `profile-service`, `vacancy-service`, `ai-service`, `fastapi_template` и `main-fe`, отдельно проверить неизменность файлов в `.github`/`.helm` и зафиксировать результаты по каждому проекту.
- [x] 3.3 Независимо выполнить `make be-build`, `make profile-build`, `make vacancy-build`, `make ai-build` и `make fe-build`, затем поднять сервисы соответствующими root Makefile-целями и проверить контейнеры/миграции, healthchecks, опубликованные порты, frontend route и логи; direct/proxy endpoint smoke и e2e фоновых процессов не применяются, поскольку runtime-контракты и процессы не меняются.
- [x] 3.4 Проверить изменения `agents/backend.md`, `agents/frontend.md` и `agents/quality_gate.md` сценариями успешной передачи и блокировки при отсутствующей, пропущенной или красной Makefile-команде; вернуть `ОДОБРЕНО` либо атомарный rework checklist со статусом `НА ДОРАБОТКУ`.
- [x] 3.5 После статуса `ОДОБРЕНО` создать `docs/reports/task-11-format-lint-test.md` по `docs/reports/TEMPLATE.md` с проверенным diff, командами, runtime/log evidence и test gaps.
