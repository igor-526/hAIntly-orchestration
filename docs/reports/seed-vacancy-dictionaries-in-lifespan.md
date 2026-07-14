# Review: seed-vacancy-dictionaries-in-lifespan

**Статус: `ОДОБРЕНО`**

## Контекст

- OpenSpec change: `openspec/changes/seed-vacancy-dictionaries-in-lifespan/`
- Затронутые сервисы: `vacancy-service`; `main-be` проверен только как существующий proxy.
- Проверенный diff: OpenSpec artifacts, migration `20260714_0005`, `utils/seeding`, lifespan, operational seed, worker/Beat, tests, compose и Makefiles.

## Проблемы

Критичных замечаний не найдено.

## Соответствие OpenSpec

- Scope: lifespan сидирует только семь `dictionary_sync_states`; HH payload остаётся в operational/Celery flow.
- Requirements/scenarios: literal UUID/name mapping, idempotency, atomic conflict rollback, metadata preservation, migration backfill и fail-fast startup покрыты и подтверждены.
- Design: seed выполняет PostgreSQL insert/select в одной транзакции; migration не вызывает runtime utility или сеть.
- Сервисные границы: данными владеет `vacancy-service`; HTTP контракт и auth boundary не изменены.
- Checklist: 22/22 задач выполнены.

## Проверки

| Сервис | Команда или сценарий | Результат | Примечание |
|---|---|---|---|
| vacancy-service | `uv run ruff format --check .`; `uv run ruff check .`; `uv run mypy src tests`; `uv run flake8 src tests` | passed | Formatting, lint и typing без ошибок. |
| vacancy-service | `make test` | passed | 35/35, 6.28 s; включая clean/backfill/collision migration, concurrent seed, lifespan и regression. |
| vacancy-service | `make vacancy-build`; operations `seed` build | passed | app, migration, worker, Beat и seed образы собраны. |
| vacancy-service | compose migration/app/worker/Beat | passed | migration exit 0; app healthy; worker ready; Beat started; startup logs без ошибок. |
| vacancy-service | lifespan с недоступным `HH_API_URL` | passed | Startup complete: lifespan не зависит от HH. |
| vacancy-service | 3 concurrent app startups + DB query | passed | Все replicas startup complete; 7 rows, 7 names, 7 UUID; metadata marker сохранён. |
| vacancy-service | operational `seed_dictionaries` | passed | Live HH sync: 7/7 terminal `success`; payload counts non-zero. |
| vacancy-service | direct LIST/GET/errors | passed | `languages`: LIST 200, `abq` GET 200, missing/family 404. |
| main-be | cookie-auth proxy LIST/GET/errors | passed | Login 204; LIST 200, GET 200, missing/family 404; secrets не выводились. |

## Безопасность

- Секреты и токены: в diff не найдены; cookie/credentials в отчёт и вывод не попали.
- Персональные данные: не затронуты.
- Auth/permissions: прямой endpoint требует `X-User-Id`; proxy проверен с cookie-auth.
- Внешние ошибки и логи: startup failure пробрасывает диагностируемую DB/schema/consistency error до readiness; API не раскрывает stack trace.

## Риски и test gaps

- Существенных test gaps нет. DB/schema/consistency fail-fast проверен unit/integration tests; real compose startup проверен на актуальной schema.

## Rework checklist

### Backend

- [x] Не требуется.

### Frontend

- [x] Не требуется.

### Quality Gate

- [x] Diff, OpenSpec и все применимые проверки повторены.
