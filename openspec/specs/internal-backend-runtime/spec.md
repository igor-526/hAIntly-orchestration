## Purpose

Определить CORS-границы публичного backend и внутренних FastAPI-сервисов HAIntly.

## Requirements

### Requirement: Внутренние FastAPI-сервисы не предоставляют браузерный CORS
`profile-service` и `fastapi_template` MUST NOT подключать CORS middleware и MUST NOT объявлять `CORS_ORIGINS`; CORS публичного `main-be` MUST оставаться доступным для `main-fe`.

#### Scenario: Запрос к profile-service с Origin
- **WHEN** клиент отправляет запрос к `profile-service` с браузерным заголовком `Origin`
- **THEN** ответ не содержит CORS allow-заголовков, добавленных приложением

#### Scenario: Новый сервис создаётся из шаблона
- **WHEN** разработчик копирует `fastapi_template` для нового внутреннего FastAPI-сервиса
- **THEN** шаблон не добавляет CORS middleware и не требует `CORS_ORIGINS`

#### Scenario: Frontend обращается к main-be
- **WHEN** `main-fe` выполняет разрешённый browser-запрос к `main-be`
- **THEN** действующий CORS-контракт `main-be` не изменён этим change
