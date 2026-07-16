## ADDED Requirements

### Requirement: Автономная конфигурация стадии pytest collection
Backend-проект MUST обеспечивать import и collection автономного pytest-набора без service `.env`, production secrets и обязательных runtime-настроек внешних интеграций. Если application-модули создают валидируемую конфигурацию при импорте, test harness MUST до такого импорта задавать явные безопасные test-only значения, MUST сохранять приоритет уже заданного окружения и MUST NOT ослаблять обязательность runtime-конфигурации вне тестов.

#### Scenario: Collection в отдельном checkout без runtime environment
- **WHEN** `vacancy-service` запускает `make test` в checkout без сервисного `.env` и без переменных HH, Celery, Redis, словарей и `profile-service`
- **THEN** pytest успешно импортирует `conftest.py` и application-модули, собирает автономный набор и не завершается ошибкой валидации `Settings`

#### Scenario: Безопасные значения не инициируют интеграции
- **WHEN** test harness задаёт фиктивные URL, DSN, token и user-agent для построения конфигурации автономных тестов
- **THEN** автономный набор не выполняет реальных обращений к HH, PostgreSQL, Redis, Celery broker/backend или `profile-service`

#### Scenario: Infrastructure environment имеет приоритет
- **WHEN** `make test-infra` заранее загрузил реальные локальные адреса и credentials из разрешённого окружения или untracked env-файла
- **THEN** test harness сохраняет эти значения и infrastructure-тесты используют подготовленную локальную инфраструктуру

#### Scenario: Runtime-запуск без обязательной конфигурации
- **WHEN** приложение или фоновый процесс `vacancy-service` запускается вне test harness без обязательного параметра внешней интеграции
- **THEN** `Settings` завершает старт с явной ошибкой валидации, не подставляя test-only значение или production default

### Requirement: Регрессия автономного запуска проверяется без локального env-файла
Изменение test configuration MUST включать автоматизированную проверку, которая воспроизводит import/collection автономного набора в очищенном окружении без использования tracked или локального service `.env`. Проверка MUST возвращать ненулевой код при повторном появлении зависимости collection от обязательной runtime-конфигурации.

#### Scenario: Локальный env-файл маскирует отсутствие переменных
- **WHEN** на рабочей машине присутствует `vacancy-service/.env`, но регрессионная проверка запускается
- **THEN** проверка изолирует subprocess или test probe от этого файла и подтверждает самодостаточность test harness

#### Scenario: Обязательный test default удалён
- **WHEN** application import снова требует runtime-поле, которое test harness не предоставляет в очищенном окружении
- **THEN** регрессионная проверка завершается с ненулевым кодом до признания `make test` совместимым с GitHub Actions
