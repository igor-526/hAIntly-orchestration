## MODIFIED Requirements

### Requirement: Аккаунты доступны только владельцу через main-be
`main-be` MUST предоставлять аутентифицированному пользователю операции LIST, GET и DELETE как proxy к `profile-service`; для OAuth complete и операций LIST, GET и DELETE `main-be` MUST передавать UUID текущего пользователя в обязательном HTTP-заголовке `X-User-Id` и MUST NOT дублировать его в JSON body, а `profile-service` MUST валидировать заголовок как UUID, ограничивать каждую операцию этим UUID и MUST NOT возвращать HH-токены. Отсутствующий или невалидный `X-User-Id` на user-scoped endpoint `profile-service` MUST возвращать `422` без выполнения операции.

#### Scenario: Список аккаунтов
- **WHEN** пользователь запрашивает свои HH-аккаунты через `main-be`
- **THEN** typed-клиент передаёт UUID пользователя в `X-User-Id`, а система возвращает только принадлежащие ему связи с безопасными UI-полями профиля и без токенов

#### Scenario: Чтение чужого аккаунта
- **WHEN** пользователь запрашивает UUID связи, принадлежащей другому пользователю
- **THEN** `profile-service` ограничивает запрос UUID из `X-User-Id` и не возвращает профиль или признак существования чужой связи

#### Scenario: Удаление аккаунта
- **WHEN** владелец удаляет свою связь
- **THEN** `profile-service` физически удаляет профиль и ciphertext токенов, а повторное удаление не раскрывает дополнительные данные

#### Scenario: OAuth complete получает пользователя из заголовка
- **WHEN** `main-be` завершает OAuth после проверки state
- **THEN** он передаёт извлечённый UUID в `X-User-Id` и code в JSON body без поля пользователя

#### Scenario: Пользовательский заголовок отсутствует или невалиден
- **WHEN** user-scoped endpoint `profile-service` получает запрос без `X-User-Id` или с невалидным UUID
- **THEN** `profile-service` возвращает `422` и не выполняет чтение, запись или удаление HH-данных
