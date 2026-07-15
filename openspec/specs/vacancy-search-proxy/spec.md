## Purpose

Определить проксирование поиска и просмотра вакансий через `main-be` с cookie-auth.

## Requirements

### Requirement: Proxy endpoint поиска вакансий
`main-be` MUST предоставлять авторизованному пользователю endpoint `GET /api/vacancies` для поиска вакансий. Endpoint MUST быть доступен только с действующей access cookie. Proxy MUST проксировать все query-параметры в vacancy-service без модификации.

#### Scenario: Авторизованный поиск
- **WHEN** пользователь с действующей cookie запрашивает `GET /api/vacancies?text=python`
- **THEN** `main-be` вызывает `vacancy-service` с `X-User-Id`, возвращает результаты поиска

#### Scenario: Авторизованный поиск с пагинацией
- **WHEN** запрос содержит `page=1&per_page=30`
- **THEN** `main-be` проксирует `page` и `per_page` в vacancy-service

#### Scenario: Неавторизованный запрос
- **WHEN** запрос не содержит действующей access cookie
- **THEN** `main-be` возвращает `401`

#### Scenario: Поиск с пресетом
- **WHEN** запрос содержит `preset_id=<uuid>`
- **THEN** `main-be` получает `hh_user_id` от profile-service и передаёт его в `X-Hh-User-Id` заголовке в vacancy-service

#### Scenario: Нет HH аккаунта при использовании пресета
- **WHEN** запрос содержит `preset_id`, но у пользователя нет привязанного HH аккаунта
- **THEN** `main-be` возвращает `400` с сообщением о необходимости привязать HH аккаунт

### Requirement: Proxy endpoint деталей вакансии
`main-be` MUST предоставлять авторизованному пользователю endpoint `GET /api/vacancies/{vacancy_id}` для получения деталей вакансии.

#### Scenario: Авторизованный запрос деталей
- **WHEN** пользователь с действующей cookie запрашивает `GET /api/vacancies/{vacancy_id}`
- **THEN** `main-be` проксирует запрос в vacancy-service с `X-User-Id`

#### Scenario: Вакансия не найдена
- **WHEN** `vacancy-service` возвращает `404`
- **THEN** `main-be` проксирует `404`

### Requirement: Стабильная обработка ошибок vacancy-service
`main-be` MUST ограничивать время внутреннего HTTP-вызова и преобразовывать timeout, недоступность и ошибки `vacancy-service` в стабильный gateway-ответ без утечки внутренних адресов.

#### Scenario: Vacancy-service недоступен
- **WHEN** внутренний вызов завершается timeout или ошибкой соединения
- **THEN** `main-be` возвращает `502` с документированной gateway-ошибкой

#### Scenario: Vacancy-service возвращает ошибку валидации
- **WHEN** `vacancy-service` возвращает `422`
- **THEN** `main-be` проксирует `422` с телом ошибки

### Requirement: Передача всех query-параметров
`main-be` MUST проксировать все query-параметры запроса `GET /api/vacancies` в `vacancy-service` без модификации. Включая `preset_id`, `text`, `experience`, `area`, `page`, `per_page` и все остальные параметры фильтрации и пагинации.

#### Scenario: Множественные значения параметра
- **WHEN** запрос содержит `area=1&area=2`
- **THEN** `main-be` передаёт оба значения в vacancy-service
