## Purpose

Определить требования к воспроизводимому локальному запуску инфраструктуры и frontend через Docker Compose.

## Requirements

### Requirement: Готовность локальной базы данных PostgreSQL
Инфраструктурная Compose-конфигурация MUST проверять готовность PostgreSQL с использованием фактически настроенных внутри контейнера пользователя и имени базы данных и MUST переводить успешно запущенный контейнер в состояние `healthy`.

#### Scenario: PostgreSQL готов принимать соединения
- **WHEN** пользователь запускает инфраструктуру через `make infra` с валидными значениями `MAIN_POSTGRES_USER`, `MAIN_POSTGRES_PASSWORD` и `MAIN_POSTGRES_DB`
- **THEN** healthcheck обращается к настроенному пользователю и базе данных, а контейнер PostgreSQL получает состояние `healthy`

#### Scenario: PostgreSQL ещё не готов
- **WHEN** PostgreSQL не принимает соединения в период запуска
- **THEN** healthcheck возвращает ошибку до готовности сервера и не сообщает ложное состояние `healthy`

### Requirement: Единая конфигурация frontend-порта
Локальная frontend-конфигурация MUST использовать значение `PORT` из переданного `.env` как порт процесса Next.js внутри контейнера и MUST публиковать этот же container port на host port с тем же номером.

#### Scenario: Frontend запускается на порту 3101
- **WHEN** в `services/main-fe/.env` задано `PORT=3101` и пользователь выполняет `make fe`
- **THEN** Next.js слушает порт `3101` внутри контейнера, а приложение доступно на host port `3101`

#### Scenario: Используется значение порта по умолчанию
- **WHEN** переменная `PORT` отсутствует в переданном окружении
- **THEN** Compose, Dockerfile и процесс Next.js используют одно документированное значение порта по умолчанию без сопоставления с другим container port

### Requirement: Воспроизводимая frontend-сборка без deprecated-зависимости
Frontend-образ MUST устанавливаться по зафиксированному lock-файлу, MUST успешно выполнять production build и MUST не содержать deprecated-пакет `whatwg-encoding` в разрешённом дереве npm-зависимостей.

#### Scenario: Сборка по актуальному lock-файлу
- **WHEN** frontend-образ собирается из неизменённых `package.json` и `package-lock.json`
- **THEN** npm устанавливает зафиксированное дерево зависимостей, production build завершается успешно и `whatwg-encoding` отсутствует в установленном дереве

#### Scenario: Manifest и lock-файл рассогласованы
- **WHEN** `package.json` и `package-lock.json` описывают несовместимые деревья зависимостей
- **THEN** установка зависимостей при сборке завершается ошибкой вместо неявного изменения lock-файла

### Requirement: Чистый вывод npm при сборке образа
Сборка frontend-образа MUST подавлять служебное уведомление npm о доступности новой major-версии CLI и MUST NOT устанавливать новую major-версию npm глобально только ради подавления этого уведомления.

#### Scenario: Для npm доступна новая major-версия
- **WHEN** используемый npm обнаруживает более новую major-версию во время Docker-сборки
- **THEN** сборочный вывод не содержит update notice, а версия npm внутри базового образа не заменяется отдельной глобальной установкой

### Requirement: Проверяемая локальная Compose-конфигурация
Проект MUST предоставлять автоматические проверки, подтверждающие корректность healthcheck PostgreSQL, итогового frontend port mapping и frontend-сборки.

#### Scenario: Статическая проверка конфигурации
- **WHEN** проверка разрешает Compose-конфигурацию со значением `PORT=3101`
- **THEN** итоговая конфигурация содержит сопоставление host/container `3101:3101` и healthcheck PostgreSQL с корректными переменными пользователя и базы данных

#### Scenario: Интеграционная проверка с доступным Docker daemon
- **WHEN** среда проверки предоставляет Docker daemon и запускает локальную инфраструктуру и frontend
- **THEN** PostgreSQL становится `healthy`, frontend-образ собирается и приложение отвечает через настроенный host port

### Requirement: Изолированные процессы Celery vacancy-service
Compose project `haintly-vacancy-service` MUST запускать Celery worker и Celery Beat как отдельные процессы `vacancy-service`, использующие общий Redis из инфраструктурного compose через валидируемое окружение. Compose сервиса MUST содержать приложение и миграции, но MUST NOT создавать собственные PostgreSQL или Redis. App MUST в FastAPI lifespan до readiness быстро и локально сидировать семь фиксированных `dictionary_sync_states`; startup seed MUST зависеть только от собственной актуальной PostgreSQL schema и MUST NOT обращаться к HH API, Redis или Celery.

#### Scenario: Запуск vacancy-service
- **WHEN** пользователь запускает compose `vacancy-service` с применёнными migrations и доступными инфраструктурными PostgreSQL и Redis
- **THEN** приложение создаёт или проверяет семь фиксированных sync states, после чего app, worker и Beat работают в проекте `haintly-vacancy-service`, а приложение проходит healthcheck на опубликованном порту `8103`

#### Scenario: Redis URL отсутствует
- **WHEN** обязательная Celery/Redis конфигурация отсутствует или невалидна
- **THEN** worker и Beat завершают запуск конфигурационной ошибкой вместо использования hardcoded broker, при этом lifespan app не использует Redis для DB seed

#### Scenario: Ошибка startup seed
- **WHEN** PostgreSQL недоступна, schema устарела либо существующие UUID/name противоречат seed definition
- **THEN** app завершается до readiness с диагностируемой ошибкой, а healthcheck не сообщает ложную готовность

#### Scenario: Внешняя сеть недоступна
- **WHEN** PostgreSQL и schema готовы, но HH API недоступен во время запуска app
- **THEN** lifespan seed не ждёт сеть, приложение проходит startup и фоновая синхронизация обрабатывает доступность HH независимо

### Requirement: Полный Makefile-пайплайн vacancy-service
Корневой Makefile MUST предоставлять `vacancy` для запуска compose и `vacancy-build` только для сборки образов без запуска, а Makefile `vacancy-service` MUST предоставлять `lint`, `format` и `test` для полного применимого пайплайна сервиса.

#### Scenario: Сборка без запуска
- **WHEN** пользователь выполняет `make vacancy-build`
- **THEN** образы `vacancy-service` собираются без запуска app, migration, worker или Beat

#### Scenario: Проверка сервиса
- **WHEN** исполнитель запускает `lint`, `format` и `test` из Makefile сервиса
- **THEN** выполняются все настроенные статические, форматирующие и тестовые проверки `vacancy-service`

### Requirement: Управляемый rebuild справочников vacancy-service
Проект MUST предоставлять документированный и автоматизируемый порядок rebuild справочников `vacancy-service`: остановка процессов записи, destructive reset только явно подтверждённой local/test БД сервиса, `alembic upgrade head`, отдельный seed, DB/runtime-проверки и запуск сервисных процессов. Обычный production startup, migration container и `alembic upgrade head` MUST NOT автоматически выполнять DROP или reset данных.

#### Scenario: Полный local/test rebuild
- **WHEN** оператор явно запускает rebuild для подтверждённой local/test БД `vacancy-service`
- **THEN** операции выполняются в порядке reset → upgrade до head → seed до terminal success → DB/runtime-проверки и не затрагивают БД других сервисов

#### Scenario: Попытка destructive reset production
- **WHEN** reset-команда обнаруживает production или production-like окружение либо не получает явного local/test подтверждения
- **THEN** она завершается ошибкой до DROP и предлагает использовать недеструктивный upgrade и отдельно контролируемый seed

#### Scenario: Обычный production deployment
- **WHEN** запускаются production migration/application процессы
- **THEN** они не выполняют автоматический reset, а seed остаётся отдельной явно запускаемой операцией

### Requirement: Проверяемая UUID-схема после rebuild
После чистого upgrade схема `vacancy-service` MUST содержать UUID primary key во всех таблицах справочников и в `dictionary_sync_states`, уникальное `dictionary_sync_states.name`, действующие domain unique constraints/FK и Alembic revision head.

#### Scenario: Проверка чистой схемы
- **WHEN** local/test reset и `alembic upgrade head` завершены
- **THEN** автоматическая проверка подтверждает UUID PK, ограничения и `alembic current=head` до запуска seed

#### Scenario: Проверка данных после seed
- **WHEN** seed достиг terminal success
- **THEN** DB-проверка подтверждает семь уникальных sync states с UUID, отсутствие дублей domain keys и непустые ожидаемые таблицы снимков
