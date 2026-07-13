## Purpose

Определить безопасную сервисную аутентификацию пользовательских запросов к `main-be` без изменения браузерного cookie-контракта.

## Requirements

### Requirement: Main-be принимает сервисную Bearer-аутентификацию пользователя
Защищённые пользовательские endpoint `main-be` MUST поддерживать два взаимоисключающих пути аутентификации: действующую access cookie браузера либо `Authorization: Bearer <service-key>` вместе с `X-User-Id`; service key MUST поступать из обязательной непустой переменной `MAIN_BE_SERVICE_KEY`, не иметь production default, сравниваться constant-time способом, а его действительное значение MUST NOT попадать в логи, ответы или tracked env-файлы.

#### Scenario: Действующий service key и пользователь
- **WHEN** микросервис отправляет верный Bearer service key и `X-User-Id` существующего пользователя
- **THEN** `main-be` загружает пользователя из своей БД и выполняет endpoint с тем же `UserOut` и ролями, которые использует cookie-путь

#### Scenario: Действующая browser cookie
- **WHEN** запрос не содержит `Authorization` и `X-User-Id`, но содержит действующую access cookie
- **THEN** `main-be` аутентифицирует пользователя по существующему cookie-контракту

#### Scenario: Service key отсутствует в окружении
- **WHEN** `main-be` запускается без `MAIN_BE_SERVICE_KEY` или с пустым значением
- **THEN** загрузка настроек завершается конфигурационной ошибкой до обслуживания запросов

### Requirement: Сервисный auth-путь не допускает fallback или подмену пользователя
Если запрос содержит `Authorization`, `main-be` MUST использовать только сервисный auth-путь; неверная схема, неверный key, отсутствующий или невалидный UUID и отсутствующий пользователь MUST возвращать `401` без fallback к cookie и без раскрытия причины. `X-User-Id` без Bearer MUST отклоняться с `401`.

#### Scenario: Неверный Bearer при действующей cookie
- **WHEN** запрос содержит действующую cookie, но также содержит неверный Bearer service key и `X-User-Id`
- **THEN** `main-be` возвращает `401` и не аутентифицирует запрос по cookie

#### Scenario: Bearer без пользовательского заголовка
- **WHEN** запрос содержит действующий service key без `X-User-Id`
- **THEN** `main-be` возвращает `401`

#### Scenario: Неизвестный пользователь
- **WHEN** запрос содержит действующий service key и корректный UUID отсутствующего пользователя
- **THEN** `main-be` возвращает `401` без раскрытия существования пользователя

#### Scenario: X-User-Id без Bearer
- **WHEN** запрос содержит `X-User-Id` без `Authorization`
- **THEN** `main-be` возвращает `401`, даже если присутствует действующая cookie
