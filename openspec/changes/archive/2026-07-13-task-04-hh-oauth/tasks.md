## 1. Backend

### profile-service

- [x] 1.1 Расширить существующий каркас `profile-service`: добавить зависимости `aiohttp` и `cryptography`, HH OAuth/redirect/`HH_TOKEN_ENCRYPT_KEY` настройки и безопасный env example, сохранив существующие параметры `.env`, compose, БД, migration container, healthcheck и Makefile-команды
- [x] 1.2 Добавить модель и миграцию связей HH с UUID пользователя HAIntly, уникальным HH user id, полным JSON-снимком профиля, ciphertext токенов, сроком access token и timestamps; покрыть ограничения migration/model tests
- [x] 1.3 Реализовать crypto-адаптер с обязательным `HH_TOKEN_ENCRYPT_KEY`, шифрованием перед записью, расшифровкой только для разрешённого использования и тестами round-trip, неверного ключа и отсутствия plaintext в persistence/DTO/logs
- [x] 1.4 Реализовать интерфейс и `aiohttp`-адаптер HH для authorization URL, обмена code и получения профиля с единым валидированным redirect URI, безопасными ошибками и автономными transport contract tests
- [x] 1.5 Реализовать транзакционный OAuth use case создания/обновления связи, запрет привязки HH user id другому владельцу и tests для success, relink, conflict и rollback при ошибке HH
- [x] 1.6 Реализовать внутренние LIST, GET и DELETE операции с UUID пользователя как типизированным полем запроса, owner scoping, безопасным account DTO без токенов и API/service tests для чужих, отсутствующих и повторно удаляемых связей
- [x] 1.7 Проверить, что расширенный `profile-service` работает в существующем локальном runtime, healthcheck остаётся успешным, а новая миграция применяется на чистой БД

### main-be

- [x] 1.8 Добавить подписанный OAuth `state` с UUID пользователя, purpose, TTL и атомарной одноразовой replay-защитой; покрыть tests для tampering, expiration, wrong purpose, replay и отсутствующей cookie на callback
- [x] 1.9 Добавить nullable active HH account UUID в пользовательскую модель `main-be`, создать миграцию с безопасным upgrade/downgrade и model/migration tests
- [x] 1.10 Реализовать typed HTTP client `profile-service` без отдельной межсервисной аутентификации, с UUID пользователя как полем контракта, timeout/error mapping и contract tests без прямого доступа к его БД
- [x] 1.11 Реализовать cookie-защищённые proxy use cases/API для старта OAuth, LIST/GET/DELETE аккаунтов и выбора активной принадлежащей связи, включая согласование active id после удаления; покрыть authorization, ownership, empty и multi-account tests
- [x] 1.12 Реализовать открытый callback `main-be`, который проверяет и погашает `state`, передаёт проверенного пользователя и code в `profile-service` и возвращает безопасный success/error DTO; покрыть callback contract и запрет утечки code/state/token
- [x] 1.13 Выполнить backend unit, API/contract и migration tests `profile-service` и `main-be`, статические проверки и локальный smoke proxy без реального HH, устранив ошибки в пределах change
- [x] 1.14 Заменить process-local replay set OAuth state на durable shared atomic consume с TTL cleanup для multi-worker/restart и покрыть multi-instance, restart, replay и expiration tests
- [x] 1.15 Устранить project-native mypy/flake8 ошибки `profile-service` и `main-be` и выполнить команды статических проверок из профиля backend
- [x] 1.16 Добавить автономные transport contract tests HH adapter и profile-service client, а также полное API/service покрытие owner scoping, multi-account, delete/retry/error сценариев
- [x] 1.17 Добавить и выполнить автономный mock-HH cross-service integration smoke `main-be → profile-service` без реальных credentials
- [x] 1.18 Доказать clean-DB/online применимость новых миграций доступным способом, отдельно зафиксировав блокер старой `main-be` migration 0002 без её изменения
- [x] 1.19 Добавить штатные PostgreSQL integration tests `OAuthStateRepository` для конкурентного consume двумя sessions, replay после нового service/repository/session и TTL cleanup expired nonce с корректным повторным использованием
- [x] 1.20 Исправить production/container dependency resolution образов `main-be` и `profile-service`, чтобы runtime содержал заявленные `aiohttp` и `cryptography`
- [x] 1.21 Пересобрать и пересоздать compose-сервисы `main-be` и `profile-service`, дождаться стабильного running/healthy без restart и проверить startup-логи
- [x] 1.22 Выполнить реальные HTTP smoke-запросы с хоста и между контейнерами к health обоих сервисов, доступному auth/HH proxy контракту `main-be` и внутреннему endpoint `profile-service`, подтвердив ожидаемые status/DTO и отсутствие runtime traceback в логах
- [x] 1.23 Выполнить regression-проверку production-сборки образов, runtime-import новых зависимостей и затронутые backend unit/static checks
- [x] 1.24 Синхронизировать HH OAuth redirect URI с каноническим frontend callback `http://localhost:3101/auth/hh/` в безопасном example и локальном runtime, доказать exact match для authorization URL и token exchange тестами и проверкой поднятого flow
- [x] 1.25 Сделать `PROFILE_SERVICE_URL` обязательной валидируемой env-настройкой `main-be` без production default/hardcode и передавать её typed HTTP client как адрес исходящей зависимости
- [x] 1.26 Перенести runtime-источник `PROFILE_SERVICE_URL` в существующий env-файл `main-be`, удалить подмену адреса из production compose и сохранить безопасную документацию в `.env.example`
- [x] 1.27 Покрыть fail-fast при отсутствующем/невалидном URL и применение env override клиентом, выполнить unit/static checks и скан hardcoded service URL
- [x] 1.28 Пересобрать и пересоздать production compose, доказать env-only конфигурацию через container inspect, health/live proxy и временный controlled endpoint override без изменения кода/image
- [x] 1.29 Исправить type-safe hermetic settings tests без `_env_file`/`type: ignore`, сохранив fail-fast контракт, и выполнить точные project checks `mypy src tests`, pytest, flake8 и ruff

## 2. Frontend

### main-fe

- [x] 2.1 Добавить типизированный HH account service/hooks для start, callback, LIST/GET/DELETE/select через `main-be` с cookie credentials, error normalization и автономными tests
- [x] 2.2 Реализовать открытый HH callback route вне общего auth gate: безопасно передавать query в `main-be`, не хранить/логировать code/state, проверять origin при `postMessage` и покрыть success/error/anonymous route tests
- [x] 2.3 Реализовать popup orchestration из пользовательского действия с обработкой блокировки, ручного закрытия, успешного сообщения, закрытия окна и обновления списка; покрыть hook/component tests
- [x] 2.4 Реализовать адаптивную шапку защищённой главной страницы с текстовым логотипом, профильным меню и доступным HH selector для добавления, выбора и подтверждённого удаления; покрыть empty, single, multi-account и error/pending tests
- [x] 2.5 Реализовать пустое состояние без активного аккаунта и исключить отображение workspace после регистрации или удаления последней связи; покрыть переходы состояния component tests
- [x] 2.6 Реализовать двухпанельный workspace shell с controls вакансий/резюме, информацией/AI controls, минимальными ширинами и доступным pointer/keyboard resize, не выполняя сетевые запросы будущих функций; покрыть desktop и narrow viewport tests
- [x] 2.7 Выполнить frontend lint, unit/component/route tests и production build, устранить ошибки в пределах change и зафиксировать недоступный реальный browser OAuth как test gap
- [x] 2.8 Исправить frontend HH OAuth completion flow: добавить канонический открытый route `/auth/hh/`, безопасный callback в `main-be`, строгое popup-сообщение/закрытие, совместимый redirect со старого пути и route/runtime regression tests без утечки code/state
- [x] 2.9 Заменить native HH selector и разнесённые действия на единый доступный dropdown с выбором, добавлением и удалением активного профиля через modal dialog; покрыть keyboard/focus, pending/error и runtime browser-like tests
- [x] 2.10 Исключить синхронную гонку двойного подтверждения DELETE через dialog in-flight guard, унифицировать закрытие modal с возвратом фокуса и покрыть deferred component и live browser regression tests
- [x] 2.11 Перенести intent восстановления фокуса после успешного DELETE на уровень `HhWorkspace`, чтобы пережить loading-unmount dropdown и сфокусировать новый активный trigger; покрыть lifecycle component и live browser tests

## 3. Quality Gate

- [x] 3.1 Отдельному Quality Gate Agent проверить diff и checklist на соответствие proposal, design, всем delta specs, `SERVICES.md`, профилям агентов и границам владения данных; вернуть `ОДОБРЕНО` или `НА ДОРАБОТКУ`
- [x] 3.2 Проверить отсутствие реальных HH credentials, `HH_TOKEN_ENCRYPT_KEY`, plaintext токенов и code/state в tracked-файлах, frontend bundle, логах и API DTO, а также отсутствие незапланированной service-key/`X-User-Id` схемы
- [x] 3.3 Выполнить доступные backend tests/static checks/migrations, frontend lint/tests/build и локальный integration smoke `main-fe → main-be → profile-service` с подменой HH; недоступные проверки явно зафиксировать
- [x] 3.4 При доступных тестовых HH credentials и зарегистрированном redirect URI выполнить ручной browser smoke popup OAuth, мультиаккаунта, выбора и удаления; иначе зафиксировать конкретный integration test gap без осабления Quality Gate
