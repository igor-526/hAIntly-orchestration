# Frontend Quality Gates

## Purpose

Определяет обязательные проверки качества, сборки и runtime для `main-fe`, а также требования к передаче реализации и независимому Quality Gate.

## Requirements

### Requirement: Строгий frontend lint
Система MUST применять к полному `src` Next.js Core Web Vitals, TypeScript и дополнительные строгие правила поддерживаемости; изменение MUST NOT понижать существующую severity, отключать правила, добавлять широкие ignore/exclusion или подавлять нарушения ради успешного lint.

#### Scenario: Успешный lint
- **WHEN** из `services/main-fe` выполняется `npm run lint`
- **THEN** весь `src` проверяется строгой конфигурацией и команда завершается с кодом 0 без lint errors

#### Scenario: Недопустимый обход
- **WHEN** реализация заменяет error на warning/off, добавляет немотивированный eslint-disable или исключает исходный файл для сокрытия нарушения
- **THEN** Quality Gate возвращает `НА ДОРАБОТКУ`, даже если команда lint завершается успешно

### Requirement: Обязательные test и typecheck
Система MUST предоставлять и успешно выполнять `npm test` и `npx tsc --noEmit` из `services/main-fe`; проверки MUST охватывать весь `src`, не требовать live backend и не оставлять persistent build-артефакты.

#### Scenario: Полный локальный gate
- **WHEN** Frontend Agent или Quality Gate Agent выполняет `npm test`, `npm run lint` и `npx tsc --noEmit`
- **THEN** каждая команда завершается с кодом 0 и отсутствие любой команды или её пропуск считается неуспешной передачей

#### Scenario: Чистота после typecheck и tests
- **WHEN** завершены test, lint и typecheck
- **THEN** рабочее дерево не содержит новых или изменённых `.next`, `out`, `build`, `coverage`, cache или TypeScript build-info файлов

### Requirement: Воспроизводимая контейнерная сборка
Система MUST успешно собирать production image `main-fe` корневой командой `make fe-build`, используя service Dockerfile и `.docker-compose/docker-compose.fe.yml`, и MUST NOT создавать или изменять build-артефакты в рабочем дереве.

#### Scenario: Сборка frontend image
- **WHEN** на чистом рабочем дереве выполняется `make fe-build`
- **THEN** production Next.js build и сборка образа завершаются с кодом 0

#### Scenario: Отсутствие host-артефактов
- **WHEN** завершена `make fe-build`
- **THEN** сравнение состояния рабочего дерева до и после не показывает новых или изменённых `.next`, `out`, `build`, coverage, cache или TypeScript build-info файлов

### Requirement: Runtime-проверка frontend
Система MUST после пересборки запускать `main-fe` корневой командой `make fe` и проверять состояние контейнера, опубликованный frontend-порт и логи.

#### Scenario: Успешный runtime smoke
- **WHEN** новый image запущен через `make fe`
- **THEN** контейнер находится в ожидаемом рабочем состоянии, frontend отвечает на опубликованном порту, а логи не содержат ошибок запуска или проверяемого пользовательского маршрута

### Requirement: Профиль Frontend Agent закрепляет архитектуру и передачу
Профиль `agents/frontend.md` MUST описывать нормативную структуру `src`, направленные зависимости, критерий feature/shared-кода, запрет прямых вызовов кроме `main-be`, запрет ослабления lint и обязательное выполнение test, lint, typecheck, image build, runtime и проверки чистоты дерева.

#### Scenario: Передача реализации Frontend Agent
- **WHEN** Frontend Agent завершает изменение кода `main-fe`
- **THEN** его отчёт содержит результаты `npm test`, `npm run lint`, `npx tsc --noEmit`, `make fe-build`, `make fe`, port/log checks и проверки отсутствия оставшихся артефактов

### Requirement: Независимый frontend Quality Gate
Профиль `agents/quality_gate.md` MUST требовать от отдельного reviewer самостоятельного выполнения test, lint, typecheck, production image build, runtime/port/log checks, архитектурной проверки и проверки отсутствия build-артефактов; reviewer MUST вернуть `НА ДОРАБОТКУ` при ошибке или пропуске любой обязательной проверки.

#### Scenario: Одобрение frontend change
- **WHEN** отдельный Quality Gate Agent проверяет готовую реализацию
- **THEN** статус `ОДОБРЕНО` возможен только после успешного выполнения всех обязательных frontend-проверок и подтверждения соответствия OpenSpec

#### Scenario: Отчёт после одобрения
- **WHEN** frontend Quality Gate завершён со статусом `ОДОБРЕНО`
- **THEN** reviewer создаёт отчёт в `docs/reports` по `docs/reports/TEMPLATE.md` с командами и доказательствами без секретов
