# Review: task-06-frontend-redesign

**Статус: `ОДОБРЕНО`**

## Контекст

- OpenSpec change: `openspec/changes/task-06-frontend-redesign/`
- Затронутые сервисы: `main-fe`; `main-be` и `profile-service` использованы только для интеграционного smoke.
- Проверенный diff: полный незакоммиченный diff вложенного репозитория `services/main-fe` относительно его `HEAD`, включая 15 изменённых/добавленных/удалённых файлов, зависимости и lock-файл; OpenSpec checklist и все delta specs.

## Проблемы

Критичных замечаний не найдено.

## Соответствие OpenSpec

- Scope: frontend-only редизайн соблюдён; backend endpoint, DTO и сервисные контракты не изменены.
- Requirements/scenarios: MUI App Router provider, обе системные палитры, эксклюзивный ToggleButton, logout, верхний Drawer, выбор, OAuth-запуск и удаление любого HH-аккаунта подтверждены кодом, тестами и runtime smoke.
- Design: единый корневой provider объединяет App Router cache, MUI theme/CssBaseline и auth; тема выводится из `prefers-color-scheme` без хранения; удаляемая связь хранится отдельно от active id; anonymous устанавливается только после успешного logout.
- Сервисные границы: браузер обращается только к настроенному публичному `main-be`; прямых вызовов HH или профильных сервисов, доступа к cookie/token и собственной persistence-модели нет.
- Checklist: выполнено 15/15 задач.

## Проверки

| Сервис | Команда или сценарий | Результат | Примечание |
|---|---|---|---|
| `main-fe` | `npm run lint` | passed | ESLint завершён без замечаний. |
| `main-fe` | `npm test` | passed | 12 test files, 58/58 tests. |
| `main-fe` | `npm run build` | passed | Next.js production build и TypeScript успешны; `/`, `/login`, `/auth/hh` сгенерированы. |
| `main-fe` | `git diff --check` | passed | Ошибок пробелов и patch formatting нет. |
| `main-fe` | `npm audit --omit=dev --json` | warning, non-blocking | Команда завершилась с кодом 1: 0 critical/high, 2 moderate для неизменённого Next.js → bundled PostCSS 8.4.31; у приложения нет пути для недоверенного CSS input, а предлагаемый audit fix является некорректным major downgrade. Force-fix не применялся. |
| `main-fe` | `make fe-build`, `make fe` | passed | Образ `haintly-main-frontend` собран, контейнер running, опубликован `3101/tcp`; отдельный Docker healthcheck не настроен. |
| `main-fe` | HTTP `/login/` и `/` | passed | Маршруты возвращают 200; `/login` ожидаемо перенаправляется 308 на trailing-slash URL. |
| `main-be` | cookie-auth → verify → `GET /api/hh/accounts` → logout → verify/refresh | passed | 204/200/200/204, после logout verify и refresh возвращают 401. Секреты и cookie не выводились. |
| `main-fe` + `main-be` | Headless Chromium, light/dark `/login` и protected `/` | passed | Палитры соответствуют системной теме, ToggleButton остаётся выбранным, hydration errors не обнаружены. |
| `main-fe` + `main-be` + `profile-service` | Headless Chromium, mobile 390×844: top Drawer, OAuth popup, выбор, удаление inactive/active, logout | passed | Для UI smoke созданы тестовые связи; проверены верхняя геометрия Drawer, active trigger, точная цель Dialog, оба удаления, возврат фокуса, disabled «Настройки» и переход на `/login`. |
| runtime | Логи `haintly-main-fe` и `haintly-main-be` | passed | Frontend ready; связанных traceback, HTTP 5xx и ошибок сценария нет; `main-be` healthy. |
| OpenSpec | `openspec validate task-06-frontend-redesign --strict` | passed | Change валиден. |

## Безопасность

- Секреты и токены: в diff не найдены; frontend не читает и не сохраняет cookie/HH token, все API-вызовы используют `credentials: include`.
- Персональные данные: новое логирование отсутствует; временные runtime-данные были тестовыми.
- Auth/permissions: logout выполняется только через существующий `POST /api/auth/logout`; успешное завершение серверной сессии и невозможность refresh после него подтверждены.
- Внешние ошибки и логи: stack trace и внутренние credentials пользователю не раскрываются; runtime-логи сценария чистые.

## Риски и test gaps

- Полное завершение реального HH OAuth у внешнего провайдера не выполнялось: runtime подтвердил получение authorization URL и открытие popup, а обработка успешного callback/reload покрыта автономными component/hook tests.
- У `main-fe` нет Docker healthcheck; работоспособность подтверждена состоянием контейнера, published port, HTTP smoke и логами. Это существующее deployment-ограничение вне scope frontend change.
- Зафиксирован moderate advisory транзитивного PostCSS в неизменённой версии Next.js. Достижимого пути обработки недоверенного CSS в HAIntly не найдено; обновление следует выполнить после выпуска совместимой исправленной версии Next.js.

## Rework checklist

### Backend

- [x] Не требуется.

### Frontend

- [x] Не требуется.

### Quality Gate

- [x] Повторно проверить diff и OpenSpec.
- [x] Повторить применимые проверки.
