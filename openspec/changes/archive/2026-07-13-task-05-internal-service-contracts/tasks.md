## 1. Backend

### main-be

- [x] 1.1 Добавить обязательный secret setting `MAIN_BE_SERVICE_KEY`, безопасный placeholder в `.env.example` и тесты отсутствующего, пустого и валидного значения.
- [x] 1.2 Расширить `AuthService` и общую dependency текущего пользователя: cookie-путь сохранить, Bearer + `X-User-Id` проверять с приоритетом, constant-time comparison и загрузкой существующего пользователя.
- [x] 1.3 Перевести защищённые endpoint, включая проверку текущего пользователя, на общую dependency и покрыть API-тестами успешные cookie/service сценарии, конфликт заголовков, неверный key, UUID и отсутствующего пользователя.
- [x] 1.4 Изменить typed-клиент `profile-service`: передавать `X-User-Id` в OAuth complete и LIST/GET/DELETE, удалить UUID из JSON body и обновить transport/unit-тесты точного HTTP-контракта.

### profile-service

- [x] 1.5 Получать обязательный UUID из `X-User-Id` на user-scoped HH endpoint, удалить пользовательский UUID из request schemas и передавать провалидированное значение в application service.
- [x] 1.6 Добавить API-тесты успешных операций с заголовком и ответов `422` при отсутствующем или невалидном `X-User-Id`, сохранив изоляцию чужих аккаунтов и отсутствие токенов.
- [x] 1.7 Удалить CORS middleware, setting/property `CORS_ORIGINS` и env example, затем добавить regression-тест отсутствия CORS allow-заголовков.

### fastapi_template

- [x] 1.8 Удалить CORS middleware, setting/property `CORS_ORIGINS` и env example из шаблона и обновить тесты health/settings для runtime без CORS.

### Runtime

- [x] 1.9 Выполнить `lint` и `test` в `main-be`, `profile-service` и `fastapi_template`, устранив ошибки без live-вызовов HH.
- [x] 1.10 Задать локальный тестовый `MAIN_BE_SERVICE_KEY`, выполнить `make be-build` и `make profile-build` без запуска, затем `make be` и `make profile`; проверить migration containers, healthchecks и логи обоих сервисов.

## 2. Quality Gate

- [x] 2.1 Независимо сопоставить полный diff с proposal, design, delta specs и checklist; проверить отсутствие секретов, изменение только заявленных HTTP/CORS-контрактов и сохранение сервисных границ.
- [x] 2.2 Повторить доступные `lint`/`test` для `main-be`, `profile-service` и `fastapi_template`, проверить сборку образов, состояние контейнеров, healthchecks и связанные логи.
- [x] 2.3 Выполнить direct smoke user-scoped endpoint `profile-service` с `X-User-Id`, включая негативный запрос без заголовка.
- [x] 2.4 Выполнить cookie-auth proxy smoke изменённого HH-потока через `main-be` для `admin@admin.ru` и `user@user.ru`, не раскрывая credentials и cookie.
- [x] 2.5 Выполнить service-auth smoke защищённого endpoint `main-be` с Bearer + `X-User-Id` и негативные проверки неверного key, отсутствующего заголовка пользователя и запрета fallback к cookie.
- [x] 2.6 При отсутствии замечаний вернуть `ОДОБРЕНО`, отметить Quality Gate и создать `docs/reports/task-05-internal-service-contracts.md` по `docs/reports/TEMPLATE.md` со всеми командами, smoke и доказательствами; при замечаниях вернуть `НА ДОРАБОТКУ` с атомарным checklist без успешного отчёта.
