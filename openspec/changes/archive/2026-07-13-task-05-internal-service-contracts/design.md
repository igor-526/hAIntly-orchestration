## Context

`main-be` сейчас извлекает пользователя только из cookie `access_token`. Его typed-клиент отправляет UUID пользователя в JSON body внутренних запросов `profile-service`, а `profile-service` и `fastapi_template` подключают CORS middleware, хотя браузер не должен обращаться к микросервисам напрямую. Обратный вызов микросервиса в защищённый пользовательский endpoint `main-be` невозможен без пользовательской cookie.

Изменение затрагивает только синхронный HTTP. Владельцем пользователей остаётся `main-be`, владельцем HH-аккаунтов — `profile-service`; БД, NATS, фоновые процессы и frontend-контракт не меняются.

## Goals / Non-Goals

**Goals:**

- разрешить доверенному микросервису вызвать защищённый endpoint `main-be` от имени существующего пользователя без cookie;
- унифицировать передачу пользовательского контекста заголовком `X-User-Id` на внутренних HTTP-границах;
- убрать браузерный CORS из закрытых backend-сервисов и шаблона;
- покрыть оба auth-пути и изменённый внутренний контракт тестами и runtime smoke.

**Non-Goals:**

- идентификация конкретного вызывающего сервиса, отдельные ключи, scopes или online-ротация;
- изменение browser cookie, JWT, публичных endpoint, HH OAuth или владения данными;
- добавление вызова `profile-service` → `main-be` в текущей реализации;
- авторизация входящих запросов `profile-service`, TLS или service mesh.

## Decisions

### 1. Один общий Bearer service key на входе main-be

`main-be` получает обязательный непустой `MAIN_BE_SERVICE_KEY` как secret setting без default. Будущий вызывающий микросервис получает тот же секрет из собственного окружения и отправляет `Authorization: Bearer <key>`. Значение не хранится в tracked env-файлах, не включается в исключения и логи и сравнивается через constant-time primitive.

Выбран стандартный `Authorization: Bearer`, а не отдельный `X-Service-Key`, согласно решению пользователя. Отдельные ключи на сервис отклонены как лишняя сложность до появления требований аудита и независимого отзыва.

### 2. Единая dependency выбирает ровно один auth-путь

Защищённые пользовательские endpoint `main-be`, включая проверку текущего пользователя, используют общую dependency:

1. Если заголовок `Authorization` присутствует, принимается только точная Bearer-схема, service key и обязательный `X-User-Id` с UUID существующего пользователя. Любая ошибка возвращает `401`; cookie не используется как fallback.
2. Если `Authorization` отсутствует, `X-User-Id` без Bearer отклоняется с `401`; иначе сохраняется действующая проверка access cookie.
3. Если одновременно переданы Bearer и cookie, приоритет имеет Bearer-путь.

Для service path `AuthService` получает пользователя по UUID из собственного репозитория и строит тот же `UserOut` с ролями, что и cookie path. Это сохраняет авторизацию endpoint по единому пользовательскому объекту и не доверяет существованию UUID только на основании заголовка.

### 3. X-User-Id заменяет body-поле в user-scoped profile API

В потоке `main-be` → `profile-service` инициатором является `main-be`, получателем — `profile-service`, протоколом — HTTP. Typed-клиент добавляет `X-User-Id` для OAuth complete и операций LIST/GET/DELETE; UUID удаляется из JSON schemas. OAuth authorization URL не получает заголовок, поскольку этот endpoint принимает только подписанный state и не выполняет user-scoped чтение или запись.

`profile-service` валидирует обязательный заголовок как UUID на транспортной границе; отсутствие или неверный формат возвращают стандартный `422`. Сервис не проверяет service key: он закрыт внутренней сетью, а владение HH-данными по-прежнему ограничивается переданным UUID.

### 4. CORS остаётся только на публичной browser-границе

Из `profile-service` и `fastapi_template` удаляются импорт и регистрация `CORSMiddleware`, setting/property `CORS_ORIGINS` и строки из env example. `main-be` сохраняет CORS, потому что `main-fe` обращается к нему из браузера. Остальные настройки и runtime шаблона не меняются.

### 5. Конфигурация и проверка

`MAIN_BE_SERVICE_KEY` принадлежит окружению принимающего `main-be`; будущий вызывающий сервис обязан получать его из собственного окружения. Адрес `PROFILE_SERVICE_URL` и существующий таймаут остаются конфигурацией `main-be`, hardcode не добавляется.

Backend Agent выполняет unit/API/transport tests, `lint`, `test`, сборку `be-build` и `profile-build`, затем поднимает оба сервиса. Quality Gate повторяет тесты, проверяет healthchecks и логи, выполняет direct smoke `profile-service`, cookie proxy smoke через `main-be`, Bearer service-auth smoke и создаёт отчёт.

## Risks / Trade-offs

- [Один общий ключ даёт доступ ко всем service-auth endpoint] → хранить только в secret environment, не логировать и заменить отдельными ключами в будущем при появлении требований scopes/аудита.
- [Компрометация ключа вместе с UUID позволяет impersonation] → обязательно проверять существование пользователя, использовать внутреннюю сеть и constant-time comparison; не принимать `X-User-Id` без валидного Bearer.
- [Перенос UUID из body ломает старый внутренний клиент] → обновить `main-be` client и `profile-service` boundary атомарно, пересобрать и перезапустить оба контейнера.
- [Обязательный setting ломает запуск без обновлённого env] → добавить безопасный placeholder в `.env.example`, перед сборкой и smoke задать реальное тестовое значение в локальном `.env`.

## Migration Plan

1. Обновить настройки и auth dependency `main-be`, затем тесты обоих auth-путей.
2. Атомарно обновить typed-клиент `main-be` и transport schemas/dependencies `profile-service` для `X-User-Id`.
3. Удалить CORS из `profile-service` и `fastapi_template`.
4. Настроить одинаковый тестовый service key в runtime environment, пересобрать и поднять `main-be` и `profile-service`.
5. Выполнить direct, proxy и service-auth smoke. При rollback вернуть оба конца `main-be` → `profile-service` одновременно и удалить обязательную переменную.

## Open Questions

Нет.
