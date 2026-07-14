## 1. Frontend

### main-fe

- [x] 1.1 Добавить совместимые с Next.js App Router зависимости Material UI, Emotion и официальной MUI-интеграции, обновив `package.json` и lock-файл без второго UI framework
- [x] 1.2 Реализовать корневой MUI provider с App Router cache, `CssBaseline` и light/dark palette по `prefers-color-scheme`, включая обновление темы без reload и детерминированный `matchMedia` test setup
- [x] 1.3 Переписать `/login` на MUI и полноширинный эксклюзивный `ToggleButtonGroup`, сохранив адаптивность, валидацию, pending/error/success и сброс чувствительного состояния, и обновить component tests
- [x] 1.4 Добавить существующий `POST /api/auth/logout` в auth service/provider, реализовать pending/error/anonymous transitions и route redirect, покрыв service и provider tests без live backend
- [x] 1.5 Переписать шапку и меню профиля на MUI, подключить рабочий «Выход» и оставить «Настройки» видимыми и disabled, покрыв interaction и error states
- [x] 1.6 Заменить HH account dropdown верхним MUI Drawer со списком, active state, выбором и OAuth-добавлением, сохранив keyboard/focus, responsive и loading/error/pending состояния
- [x] 1.7 Реализовать удаление активного и неактивного HH-аккаунта из соответствующей строки Drawer через MUI confirmation Dialog с правильным target id, защитой от повторной отправки и retryable error, обновив hook/component regression tests
- [x] 1.8 Перевести workspace shell, HH OAuth callback и общие loading/empty/error состояния на MUI/theme tokens и удалить неиспользуемые feature-specific глобальные CSS-компоненты
- [x] 1.9 Выполнить автономные `npm run lint`, `npm test` и `npm run build` в `services/main-fe`, устранив ошибки и проверив отсутствие live backend dependency
- [x] 1.10 Выполнить `make fe-build`, затем `make fe`, проверить опубликованный frontend-порт, доступность `/login` и `/`, состояние и логи контейнера до передачи в Quality Gate

## 2. Quality Gate

- [x] 2.1 Отдельному Quality Gate Agent проверить diff `main-fe` против proposal, design и всех delta specs, включая сервисные границы, cookie-auth, отсутствие сохранения темы и чувствительных данных
- [x] 2.2 Выполнить применимые frontend lint, unit/component tests и production build, проверив coverage light/dark, ToggleButton, logout, Drawer, выбор и удаление любого HH-аккаунта
- [x] 2.3 Пересобрать и поднять изменённый frontend-контейнер, проверить published port/health, маршруты и логи связанных `main-fe` и `main-be` контейнеров
- [x] 2.4 Выполнить runtime smoke в светлой и тёмной системной теме для `/login`, защищённой главной страницы, адаптивного верхнего Drawer, выбора/добавления/удаления HH-аккаунта и выхода через `main-be`, не включая secrets, cookie или credentials в отчёт
- [x] 2.5 После вердикта `ОДОБРЕНО` создать отчёт `docs/reports/task-06-frontend-redesign.md` по `docs/reports/TEMPLATE.md`
