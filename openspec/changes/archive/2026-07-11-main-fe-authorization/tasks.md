## 1. Backend

### main-be

- [x] 1.1 Дополнить API contract tests для `POST /api/auth/register`, `POST /api/auth/token`, `POST /api/auth/refresh` и `GET /api/auth/verify`, зафиксировав фактические JSON DTO, статусы, HttpOnly cookie и формат ошибок без изменения production-контракта

## 2. Frontend

### main-fe

- [x] 2.1 Настроить `npm run dev` на порт `3100`, добавить test scripts и зависимости Vitest, jsdom и React Testing Library с общим test setup
- [x] 2.2 Создать auth-типы, чистые validators для форм входа и регистрации и unit tests для валидных, пустых и граничных значений контракта `main-be`
- [x] 2.3 Реализовать общий API client с обязательным `NEXT_PUBLIC_API_BASE_URL`, JSON/error normalization, `credentials: "include"` и tests для `201`, пустого `204`, строкового/массивного `detail`, network error и отсутствующей конфигурации
- [x] 2.4 Реализовать auth feature service для register, token, verify и refresh с точной сериализацией существующего публичного контракта `main-be` и unit tests без live backend
- [x] 2.5 Реализовать auth provider/hook с состояниями `checking`, `authenticated`, `anonymous`, `error`, однократным refresh, объединением параллельных refresh и tests для success, invalid session, retry и отсутствия циклов
- [x] 2.6 Реализовать hook сценария `/login` для переключения режимов, field/submit errors, pending-блокировки, успешной регистрации без auto-login и входа с verify перед навигацией; покрыть orchestration unit tests
- [x] 2.7 Реализовать адаптивный auth UI с надписью «HAIntly», полноширинным переключателем, семантическими формами, доступными сообщениями и component tests для обоих режимов, validation, pending, backend error и success
- [x] 2.8 Добавить маршрут `/login`, перенаправление аутентифицированного пользователя на `/` и route tests для checking, anonymous, authenticated и error/retry состояний
- [x] 2.9 Заменить стартовый маршрут `/` защищённой минимальной заглушкой, исключить показ содержимого до verify и добавить route tests для loading, redirect гостя, retry ошибки и успешного отображения
- [x] 2.10 Подключить provider в root layout, обновить русские metadata/глобальные стили и документировать `NEXT_PUBLIC_API_BASE_URL` и требование разрешить origin `http://localhost:3100` в окружении `main-be`
- [x] 2.11 Выполнить `npm run lint`, frontend test script и `npm run build`, устранить ошибки в пределах change и зафиксировать недоступные интеграционные проверки как test gap
- [x] 2.12 Устранить `no-explicit-any` в frontend-тестах и настроить автономный API URL для Vitest с отдельной проверкой отсутствующей production-конфигурации
- [x] 2.13 Добавить tests `AuthProvider` для success, invalid session, single refresh, concurrent refresh coalescing, отсутствия retry loop и безопасного retry после ошибки
- [x] 2.14 Добавить orchestration tests `useLogin` для регистрации без auto-login, login → verify → navigation, ошибок и pending-блокировки
- [x] 2.15 Расширить component tests реальными interaction-сценариями регистрации, validation, success, backend error и pending
- [x] 2.16 Расширить route tests для redirect аутентифицированного пользователя с `/login`, protected error/retry и вызова retry
- [x] 2.17 Повторно выполнить frontend lint, tests и build после исправлений Quality Gate
- [x] 2.18 Добавить локальную и шаблонную конфигурацию `NEXT_PUBLIC_API_BASE_URL=http://localhost:8101`, документировать root orchestration и standalone порт, выполнить frontend lint, tests и build

## 3. Quality Gate

- [x] 3.1 Проверить diff отдельным Quality Gate Agent на соответствие proposal, design, spec, `SERVICES.md`, frontend-профилю и запрету хранения/логирования паролей и токенов
- [x] 3.2 Выполнить доступные backend contract tests и frontend lint/tests/build, проверить автономность frontend-тестов без live backend и вернуть `ОДОБРЕНО` либо атомарный список задач `НА ДОРАБОТКУ`
- [x] 3.3 При доступном локальном `main-be` проверить браузерный сценарий регистрации, входа, refresh и redirects с origin `http://localhost:3100`, иначе явно зафиксировать этот integration test gap
- [x] 3.4 Повторно проверить env-настройку `main-fe`, tracked-шаблон, документацию и frontend lint/tests/build после задачи 2.18
