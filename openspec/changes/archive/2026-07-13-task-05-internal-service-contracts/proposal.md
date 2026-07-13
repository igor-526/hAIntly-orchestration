## Why

Текущий внутренний HTTP-контракт непоследователен: `main-be` принимает пользовательский контекст только из cookie, `profile-service` получает UUID пользователя в body, а внутренние FastAPI-сервисы наследуют браузерный CORS из шаблона. Это мешает безопасным обратным вызовам микросервисов в `main-be` и закрепляет лишнюю публичную конфигурацию на закрытой сетевой границе.

## What Changes

- Добавить альтернативную сервисную аутентификацию защищённых пользовательских endpoint `main-be` через общий ключ в `Authorization: Bearer` и обязательный `X-User-Id`.
- Сохранить cookie-аутентификацию браузера; при наличии Bearer-заголовка проверять только сервисный путь без fallback к cookie.
- **BREAKING**: перевести user-scoped вызовы `main-be` → `profile-service` с UUID пользователя в JSON body на заголовок `X-User-Id`.
- Удалить CORS middleware и `CORS_ORIGINS` из `profile-service` и `fastapi_template`; CORS публичного `main-be` не менять.
- Добавить конфигурацию общего service key через обязательный `MAIN_BE_SERVICE_KEY` без значения по умолчанию и исключить секрет из логов и tracked env-файлов.
- Добавить контрактные тесты, сборку и запуск контейнеров, direct/proxy/service-auth smoke и независимый Quality Gate.
- Вне scope: отдельные ключи и идентификаторы вызывающих сервисов, ротация ключа без рестарта, TLS/service mesh, авторизация входящих запросов `profile-service`, frontend-изменения и новые вызовы `profile-service` → `main-be`.

## Capabilities

### New Capabilities

- `internal-service-auth`: альтернативная Bearer-аутентификация микросервисов в `main-be`, получение пользователя из `X-User-Id` и правила отказа.
- `internal-backend-runtime`: отсутствие CORS у внутренних FastAPI-сервисов и в шаблоне новых микросервисов.

### Modified Capabilities

- `hh-account-linking`: идентификация пользователя в user-scoped HTTP-вызовах `main-be` → `profile-service` переносится из body в `X-User-Id`.

## Impact

- `main-be`: auth dependency, настройки, HTTP-клиент `profile-service`, env example и тесты.
- `profile-service`: HTTP boundary, схемы запросов, удаление CORS-настройки и тесты.
- `fastapi_template`: удаление CORS middleware и шаблонной настройки.
- Внутренний HTTP API меняется только между `main-be` и `profile-service`; БД, миграции, frontend, HH API и NATS не затрагиваются.
