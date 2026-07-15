## Purpose

Определить внутренний API поиска вакансий через HH API в `vacancy-service` с использованием application token.

## Requirements

### Requirement: Application token для HH API
Vacancy-service MUST использовать application token (`HH_APP_TOKEN` из окружения) для авторизации запросов к HH API `GET /vacancies` и `GET /vacancies/{id}`. Application token является бессрочным и не требует refresh. Токен MUST быть задан в валидируемом окружении; отсутствие MUST блокировать запуск сервиса.

#### Scenario: Конфигурация application token
- **WHEN** `HH_APP_TOKEN` задан в окружении
- **THEN** vacancy-service использует его для всех запросов к HH API `/vacancies`

#### Scenario: Отсутствие application token
- **WHEN** `HH_APP_TOKEN` не задан
- **THEN** vacancy-service не стартует с конфигурационной ошибкой

### Requirement: Endpoint поиска вакансий
`vacancy-service` MUST предоставлять endpoint `GET /internal/vacancies`, выполняющий поиск вакансий через HH API `GET /vacancies`. Endpoint MUST требовать заголовок `X-User-Id` (UUID). Заголовок `X-Hh-User-Id` (строка) является опциональным и нужен только при использовании пресетов фильтров. Endpoint MUST поддерживать параметры пагинации `page` (int, по умолчанию 0) и `per_page` (int, по умолчанию 30, максимум 100).

#### Scenario: Поиск без фильтров
- **WHEN** запрос не содержит параметров фильтрации (все null)
- **THEN** выполняется запрос к HH `GET /vacancies` с дефолтными page=0 и per_page=30, возвращается ответ HH

#### Scenario: Поиск с параметрами фильтрации
- **WHEN** запрос содержит `text=python`, `experience=between1And3`
- **THEN** выполняется запрос к HH с переданными параметрами

#### Scenario: Поиск по пресету
- **WHEN** передан только `preset_id` и `X-Hh-User-Id`
- **THEN** загружается пресет по ID, его параметры передаются в HH API

#### Scenario: Поиск по пресету без X-Hh-User-Id
- **WHEN** передан `preset_id` без `X-Hh-User-Id`
- **THEN** возвращается `400`

#### Scenario: Поиск по пресету с переопределением
- **WHEN** передан `preset_id`, `X-Hh-User-Id` и `text=java`
- **THEN** загружается пресет, `text` переопределяется значением `java`, остальные параметры берутся из пресета

#### Scenario: Отсутствует X-User-Id
- **WHEN** запрос не содержит `X-User-Id`
- **THEN** возвращается `400`

#### Scenario: Пресет не найден
- **WHEN** `preset_id` указывает на несуществующий пресет
- **THEN** возвращается `404`

#### Scenario: Пресет принадлежит другому пользователю
- **WHEN** `preset_id` принадлежит другому `hh_user_id`
- **THEN** возвращается `404`

#### Scenario: Пагинация — запрос второй страницы
- **WHEN** запрос содержит `page=1&per_page=30`
- **THEN** выполняется запрос к HH с `page=1&per_page=30`, возвращается вторая страница результатов

#### Scenario: Пагинация — превышение лимита per_page
- **WHEN** запрос содержит `per_page=200`
- **THEN** vacancy-service ограничивает `per_page=100` (максимум HH API)

### Requirement: Endpoint деталей вакансии
`vacancy-service` MUST предоставлять endpoint `GET /internal/vacancies/{vacancy_id}`, получающий полные детали вакансии из HH API `GET /vacancies/{vacancy_id}`. Endpoint MUST требовать `X-User-Id`.

#### Scenario: Успешное получение деталей
- **WHEN** запрашивается существующая вакансия с валидным заголовком
- **THEN** выполняется запрос к HH `GET /vacancies/{vacancy_id}`, возвращается полный ответ

#### Scenario: Вакансия не найдена
- **WHEN** HH API возвращает 404
- **THEN** vacancy-service возвращает `404`

### Requirement: Метод поиска в HH клиенте vacancy-service
В `HHClient` vacancy-service MUST быть добавлен метод `search_vacancies(params: dict)`, выполняющий `GET /vacancies` к HH API с авторизацией через application token. Метод MUST возвращать dict с полями `items`, `found`, `pages`, `per_page`, `page`. Параметры `page` и `per_page` MUST передаваться в HH API.

#### Scenario: Успешный поиск
- **WHEN** вызван `search_vacancies` с параметрами (включая page, per_page)
- **THEN** HH API возвращает результаты поиска с метаданными пагинации

#### Scenario: HH API возвращает ошибку авторизации
- **WHEN** HH API возвращает 401 или 403
- **THEN** метод выбрасывает исключение с информацией об ошибке

### Requirement: Метод получения деталей в HH клиенте vacancy-service
В `HHClient` vacancy-service MUST быть добавлен метод `get_vacancy(vacancy_id: str)`, выполняющий `GET /vacancies/{vacancy_id}` к HH API с application token.

#### Scenario: Успешное получение деталей
- **WHEN** вызван `get_vacancy` с валидным ID
- **THEN** HH API возвращает полные данные вакансии

### Requirement: Параметры поиска из пресета
При передаче `preset_id` vacancy-service MUST загрузить пресет из БД, извлечь все скалярные и мультиселект-параметры и передать их в HH API. Мультиселект-параметры MUST передаваться как повторяющиеся query-параметры (например, `area=1&area=2`).

#### Scenario: Мультиселект из пресета
- **WHEN** пресет содержит `area=["1", "2"]` в `filter_preset_values`
- **THEN** в HH API передаётся `area=1&area=2`

#### Scenario: Скалярные из пресета
- **WHEN** пресет содержит `salary=100000`, `currency=RUR`
- **THEN** в HH API передаётся `salary=100000&currency=RUR`

### Requirement: Различение явного null и отсутствия параметра
Vacancy-service MUST различать явно переданный `null`/пустую строку и отсутствие параметра в запросе. Если параметр отсутствует и пресет не передан — параметр не включается в запрос к HH. Если параметр передан как `null`/пустая строка — параметр не включается в запрос к HH (сброс значения пресета).

#### Scenario: Параметр отсутствует — берётся из пресета
- **WHEN** передан `preset_id` и не передан `text`
- **THEN** `text` берётся из пресета

#### Scenario: Параметр передан как пустая строка — сбрасывается
- **WHEN** передан `preset_id` и `text=""` (пустая строка)
- **THEN** `text` не передаётся в HH API (переопределение пустым значением)

### Requirement: Валидация заголовков internal API
Vacancy-service MUST валидировать `X-User-Id` (валидный UUID). Отсутствие или невалидность MUST возвращать `400`.

#### Scenario: Невалидный X-User-Id
- **WHEN** `X-User-Id` не является UUID
- **THEN** возвращается `400`
