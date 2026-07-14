## Context

`vacancy-service` владеет таблицей `dictionary_sync_states`. Сейчас строки состояний создаются лениво во время Celery/operational sync, а UUID модели имеет `uuid4` default. Поэтому семь известных logical names получают разные UUID в чистых БД. В `main-be` уже используется локальный pattern `src/utils/seeding`: async utility выполняется в lifespan до `yield` и идемпотентно создаёт системные строки с зафиксированными UUID.

Изменение касается только реестра состояний. Динамические HH payload по-прежнему получает существующий адаптер через подтверждённые локальной OpenAPI и официальным Redoc публичные GET-операции; Celery/Beat и отдельная operational seed-команда остаются инициаторами этого потока. Lifespan не обращается к HH, Redis, Celery или чужим сервисам.

## Goals / Non-Goals

**Goals:**

- создать в `vacancy-service/src/utils/seeding` единый async seed utility для ровно семи `dictionary_sync_states`;
- закрепить явные UUID constants за logical names `dictionaries`, `areas`, `countries`, `professional_roles`, `industries`, `metro`, `languages`;
- запускать utility в lifespan до `yield`, fail-fast при schema/DB/consistency error;
- обеспечить идемпотентность повторного и конкурентного startup;
- сохранить operational sync/seed и публичный API без изменения контрактов.

**Non-Goals:**

- загрузка или ожидание terminal success HH dictionaries в lifespan;
- хранение HH payload в seed definitions или migrations;
- детерминированные UUID для строк самих справочников;
- изменение Celery/Beat расписания, HTTP/SSE/NATS контрактов, auth или service ownership.

## Decisions

### 1. Явная таблица семи UUID constants является каноническим seed definition

В модуле `utils/seeding` хранится неизменяемое отображение `logical name → UUID`, содержащее ровно семь поддерживаемых names. UUID задаются literal constants и тестируются как публичный внутренний контракт. Это напрямую выполняет требование фиксированных UUID и позволяет review обнаруживать случайное изменение идентификатора.

Альтернатива UUIDv5 отклонена: вычисляемый UUID детерминирован, но пользователь явно требует фиксировать UUID в сидах; literal mapping проще проверить и не требует скрытого namespace contract.

### 2. Lifespan выполняет только локальный async DB seed до `yield`

`main.py` вызывает `seed_dictionary_sync_states()` до `yield`; `close_database()` остаётся в `finally`, чтобы shutdown cleanup выполнялся и после последующего runtime. Utility использует `SessionFactory` и одну короткую транзакцию. Ошибка соединения, отсутствие таблицы/актуальной схемы или consistency conflict пробрасывается и прерывает FastAPI startup, поэтому health endpoint не становится доступен.

HH sync в lifespan отклонён: внешняя сеть сделала бы readiness медленной и зависимой от HH. Владелец данных остаётся `vacancy-service`; инициатор startup seed — app lifespan; получатель — собственный PostgreSQL; протокол — локальный SQL через repository/session boundary.

### 3. Idempotent insert по name дополняется строгой consistency-проверкой

Для каждой пары выполняется PostgreSQL `INSERT ... ON CONFLICT (name) DO NOTHING` либо эквивалентный repository operation. После insert utility в той же транзакции читает все семь строк и требует точного совпадения name и UUID. Отсутствующая строка, UUID занятый другим name или существующий name с иным UUID считается configuration/data consistency error; startup не переписывает PK автоматически.

Уникальность `name`, PK `id` и транзакция обеспечивают корректность concurrent replicas без Redis lock. Один replica вставляет строку, остальные видят каноническую пару после разрешения конфликта. Redis lock отклонён как лишняя инфраструктурная зависимость для локального идемпотентного insert.

### 4. Migration/backfill отделяется от runtime seed

Alembic migration не вызывает seed utility, сеть или HH. Для существующих окружений migration/backfill должен привести семь sync-state UUID к каноническим constants с сохранением status/timestamps/error и безопасным обновлением всех реальных FK-ссылок, если такие ссылки существуют; перед заменой проверяются UUID collisions. При невозможности согласовать данные migration завершается ошибкой без частичного commit. После rollout runtime seed только обеспечивает наличие и проверяет consistency.

Это предпочтительнее скрытой замены PK на каждом startup: миграция наблюдаема, версионируема и отделяет data transition от readiness path. Строки dictionary payload и их UUID не меняются.

### 5. Operational seed переиспользует прежний sync lifecycle

`seed_dictionaries.py` продолжает явно запускать семь HH sync и проверять terminal states. При необходимости он может сначала вызвать тот же local sync-state utility, но не дублирует fixed mapping и не переносится в lifespan. Celery worker/Beat используют те же logical names и находят заранее созданные states по `name`.

API остаётся внутренним HTTP-контрактом `vacancy-service` и `main-be` по HH ID; `X-User-Id` и service credential не меняются. Seed не обрабатывает пользовательский UUID, credentials или персональные данные.

## Risks / Trade-offs

- [Существующая строка имеет другой UUID] → явный migration/backfill до rollout; runtime consistency check fail-fast вместо скрытой коррекции PK.
- [Два replicas стартуют одновременно] → unique `name`, UUID PK, conflict-safe insert и проверка в одной транзакции; тест конкурентного startup.
- [Миграция не применена] → lifespan завершается schema error до readiness; migration container остаётся обязательной зависимостью deployment.
- [Startup становится зависимым от БД] → это уже обязательная runtime-зависимость сервиса; seed ограничен семью локальными insert/select без сети и retry loops.
- [Случайно изменён constant] → fixture/contract tests фиксируют все семь UUID и выявляют drift.
- [Lifespan ошибочно запускает HH sync] → тесты запрещают вызовы HH/Celery/Redis и проверяют быстрый startup при недоступном HH.

## Migration Plan

1. Зафиксировать семь UUID constants и добавить Alembic migration/backfill с collision checks и сохранением полей состояний.
2. Добавить `utils/seeding`, unit/integration tests и вызвать utility в lifespan до `yield`.
3. Сохранить operational seed/Celery/Beat отдельно и выполнить regression tests их работы с заранее созданными states.
4. Собрать образы, применить migration к local/test БД, поднять app/worker/Beat и проверить health/logs/API.
5. Повторить и конкурентно смоделировать startup, подтвердить ровно семь канонических пар и отсутствие HH network calls из lifespan.

Rollback: откатить код lifespan; данные семи sync states можно оставить с фиксированными UUID, поскольку `name` остаётся domain key и API их не раскрывает. Destructive reset не требуется. Downgrade PK допускается только при доказанной необходимости и должен сохранять status/timestamps.

## Open Questions

Нет открытых вопросов.
