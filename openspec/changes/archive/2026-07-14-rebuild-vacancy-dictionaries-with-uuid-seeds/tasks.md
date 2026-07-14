## 1. Backend

### vacancy-service

- [x] 1.1 Обновить модели всех реляционных таблиц справочников на UUID primary key, добавить UUID `id` в `dictionary_sync_states` и оставить `name` обязательным unique domain key.
- [x] 1.2 Обновить иерархические связи, typing и repository queries так, чтобы upsert выполнялся по HH domain keys и сохранял UUID существующих записей.
- [x] 1.3 Подготовить Alembic head, воспроизводимо создающий UUID PK, unique/FK и индексы на чистой БД без сетевых запросов и HH payload в миграциях.
- [x] 1.4 Добавить миграционные тесты чистого `upgrade head`, типов UUID, `dictionary_sync_states.name UNIQUE`, domain constraints/FK и соответствия Alembic revision head.
- [x] 1.5 Добавить unit/integration-тесты sync repository для генерации UUID, неизменности UUID при повторном upsert, деактивации/реактивации и идемпотентного создания sync state по `name`.
- [x] 1.6 Реализовать отдельный seed entrypoint, использующий штатные типизированный HH-адаптер, транзакции и Redis locks для семи логических справочников без дублирования sync-логики.
- [x] 1.7 Реализовать ограниченное ожидание и проверку terminal success всех семи sync states с корректными exit codes и безопасной диагностикой failure/timeout.
- [x] 1.8 Добавить тесты seed для чистой мигрированной БД, отсутствующей схемы, полного успеха, частичного отказа, timeout, невалидной конфигурации и отсутствия утечек payload/секретов в логах.
- [x] 1.9 Добавить e2e-тест повторного seed, подтверждающий отсутствие дублей и сохранение UUID записей и `dictionary_sync_states` по domain keys.
- [x] 1.10 Добавить явную guarded reset-команду только для local/test БД `vacancy-service`, которая отказывает до DROP без безопасного окружения и никогда не запускается из production startup или обычного migration flow.
- [x] 1.11 Добавить Makefile/compose entrypoints и документацию порядка stop writers → reset → `alembic upgrade head` → seed → DB/runtime checks, не добавляя PostgreSQL/Redis в compose сервиса.
- [x] 1.12 Добавить автоматические проверки отказа reset в production-like окружении и того, что reset не затрагивает БД других сервисов.
- [x] 1.13 Выполнить сервисные `format`, `lint` и полный `test`, исправив выявленные отклонения в пределах change.
- [x] 1.14 Собрать изменённые образы через `vacancy-build` без запуска и проверить успешное завершение сборки.
- [x] 1.15 На подтверждённой local/test БД остановить процессы записи, выполнить guarded reset и `alembic upgrade head`, затем проверить UUID-схему, ограничения и Alembic head.
- [x] 1.16 Запустить seed, дождаться terminal success семи справочников и проверить UUID sync states, уникальность domain keys и непустые ожидаемые таблицы.
- [x] 1.17 Повторно запустить seed и штатную синхронизацию, подтвердив сохранение UUID, отсутствие дублей и корректное обновление `last_success_at`.
- [x] 1.18 Поднять app, worker и Beat в compose project `haintly-vacancy-service`, дождаться healthcheck и проверить логи всех изменённых контейнеров без утечек и runtime-ошибок.
- [x] 1.19 Выполнить direct LIST/GET smoke `vacancy-service` по HH ID с валидным `X-User-Id` и авторизованный proxy smoke через `main-be`, подтвердив обратную совместимость и отсутствие требования локального UUID в API.
- [x] 1.20 Убрать безусловный `DROP TABLE ... CASCADE` из обычного Alembic upgrade `20260714_0004`: production migration flow должен быть недеструктивным, а удаление одноразовых local/test данных должно выполняться только отдельной guarded reset-командой.
- [x] 1.21 Добавить миграционный тест upgrade существующей схемы с контрольными строками, подтверждающий, что обычный `alembic upgrade head` не удаляет таблицы или данные; отдельно сохранить тест чистого reset → upgrade для UUID-схемы.

## 2. Quality Gate

- [x] 2.1 Отдельно проверить diff на соответствие proposal/design/specs, сервисным границам, HH OpenAPI/официальному Redoc и запрету destructive production reset.
- [x] 2.2 Проверить миграционную историю и на изолированной local/test БД повторить reset → upgrade head, подтвердив UUID PK всех таблиц, unique `dictionary_sync_states.name`, domain constraints/FK и отсутствие затрагивания чужих БД.
- [x] 2.3 Выполнить применимые `format`/`lint`/полные тесты `vacancy-service`, сборку изменённых образов без запуска и зафиксировать результаты.
- [x] 2.4 Поднять связанные контейнеры, проверить health и изучить логи migration/app/worker/Beat на runtime-ошибки и утечки секретов или HH payload.
- [x] 2.5 Выполнить seed e2e до terminal success семи снимков и повторный seed/sync с DB-проверкой неизменности UUID, отсутствия дублей, активности и `last_success_at`.
- [x] 2.6 Выполнить direct API smoke `vacancy-service` и авторизованный proxy smoke через `main-be` для LIST/GET по HH ID, включая ожидаемые ошибки и подтверждение неизменности контракта.
- [x] 2.7 Вернуть `ОДОБРЕНО` либо `НА ДОРАБОТКУ`; при одобрении создать отчёт в `docs/reports` по `docs/reports/TEMPLATE.md` без секретов и credentials.
- [x] 2.8 После исправления повторить независимый Quality Gate миграционной истории, production-like upgrade/refusal, local/test reset → upgrade, seed/sync e2e и runtime/API smoke.
