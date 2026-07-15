## Purpose

Определить проксирование CRUD операций с пресетами фильтров через `main-be` к `vacancy-service` с cookie-auth и передачей пользовательского контекста.

## ADDED Requirements

### Requirement: Proxy CRUD endpoints в main-be
`main-be` MUST предоставлять авторизованному пользователю CRUD endpoints для пресетов фильтров: `GET /api/filters` (LIST), `GET /api/filters/{preset_id}` (GET), `POST /api/filters` (CREATE), `PATCH /api/filters/{preset_id}` (UPDATE), `DELETE /api/filters/{preset_id}` (DELETE). Все endpoints MUST быть доступны только с действующей access cookie.

#### Scenario: Авторизованный proxy-запрос LIST
- **WHEN** пользователь с действующей cookie запрашивает `GET /api/filters`
- **THEN** `main-be` вызывает `vacancy-service`, передаёт `X-User-Id` и `X-Hh-User-Id`, возвращает список пресетов

#### Scenario: Неавторизованный запрос
- **WHEN** запрос не содержит действующей access cookie
- **THEN** `main-be` возвращает `401` и не вызывает `vacancy-service`

#### Scenario: Создание пресета через proxy
- **WHEN** авторизованный пользователь отправляет `POST /api/filters` с валидным телом
- **THEN** `main-be` проксирует запрос в `vacancy-service` и возвращает `201` с созданным пресетом

#### Scenario: Обновление пресета через proxy
- **WHEN** авторизованный пользователь отправляет `PATCH /api/filters/{preset_id}`
- **THEN** `main-be` проксирует запрос и возвращает `200` с обновлённым пресетом

#### Scenario: Удаление пресета через proxy
- **WHEN** авторизованный пользователь отправляет `DELETE /api/filters/{preset_id}`
- **THEN** `main-be` проксирует запрос и возвращает `204`

### Requirement: Передача пользовательского контекста в vacancy-service
При каждом proxy-вызове фильтров `main-be` MUST передавать `X-User-Id` (UUID авторизованного пользователя из cookie) и `X-Hh-User-Id` (строка — hh_user_id выбранного HH аккаунта). Для получения `hh_user_id` `main-be` MUST делать前置ный запрос к `profile-service` (`GET /internal/hh-accounts/selected`).

#### Scenario: Получение hh_user_id от profile-service
- **WHEN** `main-be` обрабатывает proxy-запрос фильтров
- **THEN** `main-be` запрашивает selected HH account у `profile-service`, получает `hh_user_id` и передаёт его в `X-Hh-User-Id`

#### Scenario: Нет привязанного HH аккаунта
- **WHEN** у пользователя нет привязанных HH аккаунтов или нет selected аккаунта
- **THEN** `main-be` возвращает `400` с сообщением о необходимости привязать HH аккаунт

### Requirement: Стабильная обработка ошибок vacancy-service
`main-be` MUST ограничивать время внутреннего HTTP-вызова и преобразовывать timeout, недоступность и ошибки `vacancy-service` в стабильный gateway-ответ без утечки внутренних адресов, credentials или traceback.

#### Scenario: Vacancy-service недоступен
- **WHEN** внутренний вызов завершается timeout или ошибкой соединения
- **THEN** `main-be` возвращает `502` с документированной gateway-ошибкой

#### Scenario: Vacancy-service возвращает ошибку валидации
- **WHEN** `vacancy-service` возвращает `422`
- **THEN** `main-be` проксирует `422` с телом ошибки

#### Scenario: Vacancy-service возвращает 404
- **WHEN** `vacancy-service` возвращает `404` (пресет не найден или принадлежит другому пользователю)
- **THEN** `main-be` проксирует `404`

### Requirement: Конфигурация зависимости vacancy-service
Адрес `vacancy-service` и timeout MUST поступать из валидируемого окружения `main-be`. Отсутствие обязательных переменных MUST блокировать запуск сервиса.

#### Scenario: Отсутствует адрес vacancy-service
- **WHEN** `VACANCY_SERVICE_URL` не задан
- **THEN** `main-be` не стартует с конфигурационной ошибкой
