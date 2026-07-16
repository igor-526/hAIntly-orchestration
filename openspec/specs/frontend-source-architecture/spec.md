# Frontend Source Architecture

## Purpose

Определяет нормативную структуру исходников `main-fe`, направления зависимостей, границу API и требования к сохранению пользовательского поведения.

## Requirements

### Requirement: Единый корень исходников frontend
Система MUST хранить все исходники, исполняемые приложением, общие типы и тестовую инфраструктуру `main-fe` внутри `services/main-fe/src`, распределяя их между `api`, `app`, `contexts`, `features`, `hooks`, `lib`, `test`, `types` и `ui`; статические assets MUST оставаться в `public`, а tooling-конфигурация — в корне сервиса.

#### Scenario: Полный перенос исходников
- **WHEN** завершён рефакторинг `main-fe`
- **THEN** в корне сервиса отсутствуют старые runtime/test исходники вне `src`, а каждый оставшийся файл относится к разрешённому source, asset или tooling-каталогу

#### Scenario: Единый alias исходников
- **WHEN** TypeScript, Vitest или приложение разрешают импорт с alias `@`
- **THEN** alias указывает на `services/main-fe/src` и одинаково работает в сборке, typecheck и тестах

### Requirement: Минимальный routing-слой
Система MUST ограничивать `src/app` Next.js routing, layout и route metadata; каждый route page MUST выполнять минимальную композицию одного feature page-компонента и MUST NOT содержать сетевые вызовы, состояние пользовательского сценария или бизнес-оркестрацию.

#### Scenario: Отображение route
- **WHEN** Next.js рендерит существующий route
- **THEN** route page подключает единый page-компонент из соответствующей feature, сохраняя прежний URL и пользовательское поведение

### Requirement: Изолированная структура feature
Система MUST размещать каждую пользовательскую feature в отдельном `src/features/<name>` и разделять её применимый код между `hooks`, `services`, `ui` и `validators`; пустые каталоги MUST NOT создаваться только ради шаблона.

#### Scenario: Оркестрация feature
- **WHEN** feature выполняет пользовательский сценарий с обращением к backend
- **THEN** feature UI делегирует состояние feature hook, hook делегирует orchestration framework-neutral service, а service использует общий API boundary

#### Scenario: Валидация feature
- **WHEN** форма feature требует клиентской валидации
- **THEN** validator находится внутри этой feature, не подменяет backend-валидацию и тестируется независимо от UI

### Requirement: Направленные зависимости слоёв
Система MUST соблюдать направление `app -> feature ui -> feature hook -> feature service -> api`; общие `contexts`, `hooks`, `lib`, `types` и `ui` MUST NOT импортировать `features` или `app`, а feature MUST NOT импортировать внутренние модули другой feature.

#### Scenario: Архитектурная проверка импортов
- **WHEN** запускается статическая проверка структуры `main-fe`
- **THEN** она завершается ошибкой при обратной зависимости shared-слоя, прямом feature-to-feature импорте или обходе API boundary

### Requirement: Переиспользуемый код находится в shared-слоях
Система MUST переносить компонент, hook, тип или функцию в корневой shared-слой только при использовании несколькими feature либо при принадлежности к общей инфраструктурной границе; feature-specific код MUST оставаться внутри feature.

#### Scenario: Повторное использование UI
- **WHEN** один UI-компонент используется минимум двумя независимыми feature
- **THEN** компонент размещается в `src/ui`, не знает о feature и получает данные и callbacks через типизированные props

#### Scenario: Локальный UI
- **WHEN** UI-компонент используется только одной feature
- **THEN** компонент остаётся в `src/features/<name>/ui`

### Requirement: Единая граница main-be
Система MUST выполнять все HTTP- и SSE-взаимодействия frontend через типизированный `src/api` только с `main-be`, используя конфигурацию окружения без hardcode и не обращаясь к профильным сервисам, HH, AI-провайдеру, NATS или БД.

#### Scenario: HTTP-вызов feature
- **WHEN** пользователь инициирует существующую команду или загрузку данных
- **THEN** feature service использует API client `main-be` и сохраняет прежние request/response mapping и auth semantics

#### Scenario: SSE-уведомление
- **WHEN** `main-be` доставляет существующее SSE-событие
- **THEN** API boundary передаёт его соответствующему hook/context без изменения wire-формата и без раскрытия чувствительных данных в логах

### Requirement: Поведение сохраняется при рефакторинге
Система MUST сохранить существующие маршруты, UX-flow, доступные состояния, HTTP/SSE-контракт и визуальную тему `main-fe`; рефакторинг MUST NOT добавлять пользовательские возможности или менять backend-контракты.

#### Scenario: Регрессия существующей feature
- **WHEN** выполняются unit/component tests перенесённой feature
- **THEN** подтверждены применимые loading, empty, error, data и interaction состояния без подключения к live backend

#### Scenario: Runtime после переноса
- **WHEN** собранный образ `main-fe` запущен через корневую compose-команду
- **THEN** существующие страницы доступны на опубликованном frontend-порту и не содержат runtime-ошибок в логах проверяемого сценария
