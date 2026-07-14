## 1. Backend

### vacancy-service

- [x] 1.1 Создать `src/utils/seeding` по существующему pattern проекта и зафиксировать в едином definition ровно семь literal UUID constants для канонических logical names `dictionary_sync_states`.
- [x] 1.2 Реализовать async seed utility с одной локальной PostgreSQL-транзакцией, conflict-safe insert по `name` и строгой постпроверкой полного отображения UUID/name без HH, Redis или Celery вызовов.
- [x] 1.3 Добавить Alembic migration/backfill существующих семи sync states на фиксированные UUID с collision checks, сохранением metadata и атомарным отказом при несовместимых данных; не добавлять сеть или HH payload в migration.
- [x] 1.4 Подключить seed utility в FastAPI lifespan до `yield`, обеспечить fail-fast при DB/schema/consistency error и гарантированный database cleanup при shutdown/ошибке startup.
- [x] 1.5 Сохранить отдельный `seed_dictionaries.py`, Celery worker и Beat для загрузки семи HH payload; устранить дублирование списка/UUID definitions и подтвердить поиск sync states по logical `name`.
- [x] 1.6 Добавить unit-тесты точных семи UUID constants, conflict-safe statement/repository поведения, полного success и UUID/name consistency conflicts.
- [x] 1.7 Добавить lifespan-тесты успешного startup, повторного startup, DB/schema failure и consistency failure до readiness, отдельно доказав отсутствие вызовов HH API, Redis и Celery.
- [x] 1.8 Добавить integration-тест конкурентного startup replicas, подтверждающий ровно семь строк, точные пары UUID/name, отсутствие дублей и неизменность sync metadata.
- [x] 1.9 Добавить migration-тесты чистого upgrade и backfill существующих status/timestamps/error, включая UUID collision rollback и соответствие Alembic head.
- [x] 1.10 Выполнить regression-тесты operational seed, scheduler/worker и dictionary API, подтвердив, что HH snapshots синхронизируются вне lifespan и фиксированные sync-state UUID сохраняются.
- [x] 1.11 Выполнить `format`, `lint` и полный `test` `vacancy-service`, исправив выявленные отклонения в пределах change.
- [x] 1.12 Собрать изменённые образы через `vacancy-build` без запуска и подтвердить успешную сборку migration/app/worker/Beat.
- [x] 1.13 Применить migrations к local/test БД, поднять compose project `haintly-vacancy-service`, дождаться app healthcheck и проверить логи migration/app/worker/Beat без runtime-ошибок и утечек.
- [x] 1.14 Повторно и конкурентно запустить app, DB-запросом подтвердить ровно семь фиксированных sync-state пар и выполнить operational sync e2e до ожидаемого внешнего эффекта вне lifespan.
- [x] 1.15 Выполнить direct LIST/GET smoke `vacancy-service` и авторизованный proxy smoke через `main-be` по существующему HH ID, подтвердив неизменность API-контракта.

## 2. Quality Gate

- [x] 2.1 Отдельно проверить diff на соответствие proposal/design/delta specs, границам `vacancy-service`, fixed UUID mapping и запрету HH/Redis/Celery вызовов из lifespan.
- [x] 2.2 Проверить Alembic migration на чистой и существующей local/test БД: fixed UUID backfill, сохранение metadata, collision rollback, отсутствие сети и соответствие revision head.
- [x] 2.3 Выполнить `format`, `lint`, полный `test` `vacancy-service` и сборку изменённых образов без запуска, зафиксировав результаты.
- [x] 2.4 Поднять migration/app/worker/Beat, проверить health и логи; отдельно проверить fail-fast app до readiness при DB/schema/consistency error и успешный startup при недоступном HH.
- [x] 2.5 Повторить и конкурентно выполнить lifespan startup, подтвердить DB-запросом ровно семь literal UUID/name пар, отсутствие дублей/изменения metadata и отсутствие внешних вызовов.
- [x] 2.6 Выполнить operational HH sync e2e и проверить terminal result, затем direct API smoke и авторизованный proxy smoke через `main-be`, подтвердив неизменность background/API границ.
- [x] 2.7 Вернуть `ОДОБРЕНО` либо `НА ДОРАБОТКУ`; при одобрении последней операцией создать отчёт в `docs/reports` по `docs/reports/TEMPLATE.md` без секретов и credentials.
