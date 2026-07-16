## 1. Frontend

### main-fe

- [x] 1.1 Зафиксировать инвентаризацию существующих route, feature, HTTP/SSE-вызовов, тестов и воспроизвести причину падения `make fe-build`, не изменяя публичное поведение.
- [x] 1.2 Настроить `src` как единый корень TypeScript/Vitest/Next.js с alias `@/* -> ./src/*` и создать только применимые каталоги `api`, `app`, `contexts`, `features`, `hooks`, `lib`, `test`, `types`, `ui`.
- [x] 1.3 Перенести типизированные HTTP/SSE-клиенты `main-be`, общие типы и framework-neutral utilities в `src/api`, `src/types` и `src/lib`, сохранив environment-конфигурацию, wire-format и auth semantics.
- [x] 1.4 Перенести общие React providers/hooks и реально межфичевые компоненты в `src/contexts`, `src/hooks` и `src/ui`, удалив их зависимости от `features` и `app`.
- [x] 1.5 Последовательно перенести каждую существующую пользовательскую feature в `src/features/<name>` с применимыми `hooks`, `services`, `ui`, `validators`, исключив feature-to-feature imports и дубли старых файлов.
- [x] 1.6 Свести каждый route page в `src/app` к одному feature page-компоненту, сохранив URL, layouts, metadata, тему и существующие пользовательские состояния без сетевых вызовов и orchestration в routing-слое.
- [x] 1.7 Перенести Vitest setup, render helpers, fixtures и HTTP/SSE mocks в `src/test` и обновить unit/component regression tests для существующих feature без live backend.
- [x] 1.8 Добавить автоматическую проверку направлений импортов и полного отсутствия runtime/test исходников вне `src`, покрыв её позитивным и негативным сценарием.
- [x] 1.9 Ужесточить ESLint поверх Next.js Core Web Vitals и TypeScript presets правилами типобезопасности, дублирования, сложности, размера и JSX handlers; исправить все нарушения без понижения severity, eslint-disable, широких ignore или исключения исходников.
- [x] 1.10 Синхронизировать `package.json`, lock-файл, TypeScript и Vitest-конфигурацию так, чтобы `npm test`, `npm run lint` и `npx tsc --noEmit` проверяли весь `src` и не создавали persistent build-info или другие host-артефакты.
- [x] 1.11 Исправить Dockerfile, `.dockerignore`, `.docker-compose/docker-compose.fe.yml` и корневой `Makefile` в минимально необходимом объёме, чтобы `make fe-build` воспроизводимо собирал production image внутри Docker без записи build-артефактов в рабочее дерево.
- [x] 1.12 Удалить устаревшие исходники, дубли и tracked generated/build-info файлы, добавить точные ignore-паттерны для generated output и подтвердить чистоту ожидаемого дерева `services/main-fe`.
- [x] 1.13 Обновить `agents/frontend.md`: закрепить нормативную `src`-архитектуру, направленные зависимости, критерий shared-кода, запрет lint-ослаблений и обязательные test/lint/typecheck/build/runtime/artifact проверки передачи.
- [x] 1.14 Обновить `agents/quality_gate.md`: обязать независимого reviewer повторять frontend test/lint/typecheck, архитектурную проверку, production image build, runtime/port/log smoke и контроль отсутствия host-артефактов.
- [x] 1.15 Выполнить из `services/main-fe` `npm test`, `npm run lint` и `npx tsc --noEmit`, зафиксировать успешные результаты и подтвердить отсутствие новых/изменённых generated-артефактов.
- [x] 1.16 Выполнить корневую `make fe-build` без запуска, подтвердить успешную production-сборку image и отсутствие новых/изменённых `.next`, `out`, `build`, coverage, cache и TypeScript build-info в рабочем дереве.
- [x] 1.17 Запустить пересобранный frontend через `make fe`, проверить состояние контейнера, доступность опубликованного порта, существующий пользовательский route и отсутствие ошибок сценария в логах до передачи в Quality Gate.
- [x] 1.18 Перенести dictionary HTTP orchestration из `src/features/workspace/filters/filter-form.tsx` в feature service/hook, запретить UI импортировать или вызывать API boundary и покрыть новую цепочку тестами.
- [x] 1.19 Расширить `src/lib/architecture.ts` проверкой relative imports и запретом прямого API boundary из feature UI, добавить негативные тесты обходов и повторить полный локальный, container и runtime gate.

## 2. Quality Gate

- [x] 2.1 Независимо сопоставить полный diff `main-fe`, `Makefile`, compose и профилей агентов с proposal, design и обеими delta specs; проверить отсутствие изменений UX, HTTP/SSE-контрактов, backend и сервисных границ.
- [x] 2.2 Проверить структуру всего `services/main-fe/src`, минимальность route pages, feature/shared ownership, направленные импорты и отсутствие старых runtime/test исходников вне `src`.
- [x] 2.3 Проверить ESLint-конфигурацию и diff на понижение severity, отключение правил, eslint-disable, широкие ignore/exclusion и иные обходы; при любом ослаблении вернуть `НА ДОРАБОТКУ`.
- [x] 2.4 На чистой установке зависимостей независимо выполнить в `services/main-fe` `npm test`, `npm run lint` и `npx tsc --noEmit`, сохранив результаты всех команд.
- [x] 2.5 Независимо выполнить корневую `make fe-build` без запуска и сравнением состояния рабочего дерева до/после подтвердить отсутствие новых или изменённых build/test/cache/typecheck-артефактов.
- [x] 2.6 Запустить пересобранный image через `make fe`, проверить состояние контейнера, опубликованный frontend-порт, критический существующий route и логи; при любой ошибке вернуть `НА ДОРАБОТКУ`.
- [x] 2.7 После результата `ОДОБРЕНО` создать отчёт в `docs/reports` по `docs/reports/TEMPLATE.md` с проверенными командами и доказательствами без credentials, cookie, token или персональных данных.
