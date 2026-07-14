## Why

Строки реестра `dictionary_sync_states` сейчас создаются по мере фоновой синхронизации со случайными UUID, поэтому их идентификаторы различаются между чистыми окружениями. Нужно быстро и локально создавать семь обязательных состояний с явно фиксированными UUID через общий lifespan-seeding pattern, не связывая запуск API с доступностью HH.

## What Changes

- Добавить `vacancy-service/src/utils/seeding` по существующему проектному pattern и вызывать его в FastAPI lifespan до `yield`.
- Хранить в seed-definition ровно семь пар `logical name → UUID` для строк `dictionary_sync_states`; UUID задаются явными фиксированными constants.
- Выполнять локальный идемпотентный insert/upsert по уникальному `name` и проверять соответствие существующего `id` ожидаемой паре; конфликт UUID/name или ошибка DB/schema прерывает startup до readiness.
- Не обращаться к HH API, Redis или Celery из lifespan и не ждать terminal success справочников: payload-продолжает загружаться существующим Celery/Beat и отдельным operational seed.
- Добавить migration/backfill policy для уже существующих sync states: сохранить согласованные строки, а несовместимые UUID не переписывать скрыто во время startup.
- Добавить проверки lifespan success/failure, фиксированных UUID, повторного и конкурентного startup, а также API/worker/runtime regression.

## Capabilities

### New Capabilities

Нет новых capabilities.

### Modified Capabilities

- `vacancy-dictionary-seeding`: lifespan создаёт только семь фиксированных строк sync state; загрузка HH payload остаётся отдельным operational seed и фоновым процессом.
- `vacancy-dictionary-sync`: реестр состояний получает каноническое отображение семи logical names на фиксированные UUID и строгую проверку согласованности.
- `local-compose-runtime`: startup выполняет быстрый локальный DB seed sync states и fail-fast при DB/schema/consistency error, не зависит от HH API.

## Impact

- `vacancy-service`: lifespan, новый `utils/seeding`, sync-state definitions/repository и тесты; operational `seed_dictionaries.py`, Celery и Beat сохраняют ответственность за HH payload.
- PostgreSQL `vacancy-service`: ровно семь канонических строк `dictionary_sync_states`; migration/backfill не выполняет сетевых вызовов.
- Redis и HH API не участвуют в lifespan seed; существующие sync locks и типизированный HH-адаптер продолжают применяться только к фоновой/операционной синхронизации.
- `main-be` и публичный API: контракты LIST/GET по HH ID не меняются; изменения кода не планируются.
- Вне scope: сидирование dictionary payload в lifespan, ожидание terminal success 7/7 при startup, статический commit HH payload, UUIDv5 для dictionary rows, пользовательские HH OAuth tokens и изменение API/SSE/NATS контрактов.
