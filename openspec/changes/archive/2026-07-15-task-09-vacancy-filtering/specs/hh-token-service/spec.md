## Purpose

Определить сервисный endpoint в `profile-service` для выдачи расшифрованного HH access token другим внутренним сервисам с поддержкой refresh.

## ADDED Requirements

### Requirement: Выдача access token по account_id
`profile-service` MUST предоставлять endpoint `GET /internal/hh-token/{account_id}`, возвращающий расшифрованный access token для указанного HH аккаунта. Endpoint MUST требовать заголовок `X-User-Id` (UUID) и MUST валидировать, что указанный `account_id` принадлежит этому пользователю.

#### Scenario: Успешное получение токена
- **WHEN** авторизованный internal клиент запрашивает `GET /internal/hh-token/{account_id}` с валидным `X-User-Id`
- **THEN** возвращается `200` с JSON `{"access_token": "<расшифрованный токен>", "expires_at": "<ISO 8601>"}`

#### Scenario: Токен не принадлежит пользователю
- **WHEN** `account_id` не принадлежит пользователю из `X-User-Id`
- **THEN** возвращается `404`

#### Scenario: Отсутствует X-User-Id
- **WHEN** запрос не содержит `X-User-Id`
- **THEN** возвращается `400`

### Requirement: Refresh токена при запросе
При передаче query-параметра `refresh=true` profile-service MUST проверять `access_token_expires_at`. Если токен протухнет в ближайшие 60 секунд, MUST быть выполнен refresh через HH OAuth endpoint `POST /oauth/token` с `grant_type=refresh_token`.

#### Scenario: Успешный refresh
- **WHEN** токен протухает в ближайшие 60 секунд и передан `refresh=true`
- **THEN** выполняется refresh, обновляются `access_token_ciphertext`, `refresh_token_ciphertext`, `access_token_expires_at` в БД, возвращается новый `access_token` и `expires_at`

#### Scenario: Refresh не требуется (токен свежий)
- **WHEN** токен не протухает в ближайшие 60 секунд и передан `refresh=true`
- **THEN** refresh не выполняется, возвращается текущий `access_token` и `expires_at`

#### Scenario: Refresh не удался — invalid_grant
- **WHEN** HH API возвращает `invalid_grant` при refresh
- **THEN** возвращается `401` с JSON `{"detail": "hh_token_refresh_failed", "account_id": "<id>"}`

#### Scenario: Refresh не удался — другая ошибка
- **WHEN** HH API возвращает иную ошибку при refresh (network, 5xx)
- **THEN** возвращается `502` с JSON `{"detail": "hh_refresh_error"}`

#### Scenario: Без refresh-параметра
- **WHEN** `refresh` не передан или `refresh=false`
- **THEN** токен возвращается как есть, без проверки expires_at

### Requirement: Метод refresh в HH клиенте profile-service
В `AiohttpHHClient` profile-service MUST быть добавлен метод `refresh_token(refresh_token: str)`, выполняющий `POST /oauth/token` к HH API с `grant_type=refresh_token`. Метод MUST возвращать `HHTokens` (access_token, refresh_token, expires_at) или выбрасывать исключение при ошибке.

#### Scenario: Успешный refresh через HH API
- **WHEN** вызван `refresh_token` с валидным refresh_token
- **THEN** HH API возвращает новые access_token, refresh_token, expires_in; метод возвращает `HHTokens`

#### Scenario: Невалидный refresh_token
- **WHEN** HH API возвращает `invalid_grant`
- **THEN** метод выбрасывает `HHRefreshError`

### Requirement: Изменения в HHAccountService
`HHAccountService` MUST получить метод `get_access_token(account_id, user_id, refresh=False)`, который: (1) загружает аккаунт, (2) при `refresh=True` — проверяет expires_at и при необходимости вызывает refresh, (3) расшифровывает и возвращает access_token и expires_at.

#### Scenario: Получение токена без refresh
- **WHEN** вызван `get_access_token` с `refresh=False`
- **THEN** расшифровывается текущий `access_token_ciphertext` и возвращается

#### Scenario: Получение токена с refresh
- **WHEN** вызван `get_access_token` с `refresh=True` и токен протухает
- **THEN** выполняется refresh, токены обновляются в БД, возвращается новый access_token
