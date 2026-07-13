# Review: task-05-internal-service-contracts

**Статус: `ОДОБРЕНО`**

## Контекст

- OpenSpec change: `openspec/changes/task-05-internal-service-contracts/`
- Затронутые сервисы: `main-be`, `profile-service`, `fastapi_template`
- Проверенный diff: полный diff root за исключением несвязанного пользовательского `docs/prompts/task_06_frontend_redesign.md`, а также полные diff отдельных worktree `services/main-be` и `services/profile-service`

## Проблемы

Критичных замечаний не найдено.

## Соответствие OpenSpec

- Scope: изменения ограничены сервисной аутентификацией `main-be`, переносом user context в `X-User-Id`, удалением CORS из внутренних runtime и тестами; frontend, БД, NATS и HH API не изменены.
- Requirements/scenarios: cookie и service auth, запрет fallback, существование пользователя, новый profile HTTP-контракт и отсутствие CORS подтверждены тестами и smoke.
- Design: обязательный `MAIN_BE_SERVICE_KEY` загружается как `SecretStr`, сравнивается через `secrets.compare_digest`, Bearer имеет приоритет; typed client и profile boundary изменены атомарно.
- Сервисные границы: пользователи остаются во владении `main-be`, HH-аккаунты — во владении `profile-service`; прямого доступа к чужой БД и новой входящей auth для `profile-service` нет.
- Checklist: 16/16 задач выполнены.

## Проверки

| Сервис | Команда или сценарий | Результат | Примечание |
|---|---|---|---|
| `main-be` | `make lint && make test` | passed | mypy и flake8 успешны, 44 теста passed |
| `profile-service` | `make lint && make test` | passed | mypy и flake8 успешны, 14 тестов passed |
| `fastapi_template` | `make lint && make test` | passed | mypy и flake8 успешны, 3 теста passed |
| Images | `make be-build`, `make profile-build` | passed | оба application и migration image собраны |
| Runtime | `make be`, `make profile`, Docker inspect и health HTTP | passed | приложения healthy; оба migration container завершились с exit 0; health вернул 200 |
| Direct smoke | `POST profile-service /internal/hh/accounts/list` | passed | для UUID обоих тестовых пользователей — 200 и безопасный список без токенов; без/с невалидным `X-User-Id` — 422 |
| Cookie proxy smoke | login, verify и `GET main-be /api/hh/accounts` | passed | оба тестовых аккаунта: login 204, verify 200, proxy 200; cookie не выводились |
| Service-auth smoke | `GET main-be /api/auth/verify` | passed | для обоих пользователей valid Bearer + `X-User-Id` — 200; wrong key, missing user header, invalid/unknown UUID, header без Bearer и wrong Bearer с valid cookie — 401 |
| CORS runtime | Origin-запросы к health | passed | `profile-service` не возвращает CORS allow headers; `main-be` сохраняет allow-origin для настроенного frontend origin |
| Logs | application и migration logs после smoke | passed | traceback/exception/error/critical не найдены; ожидаемые HTTP 200/204/401/422 подтверждены access logs |
| OpenSpec | `openspec validate --all --strict --no-interactive`, `openspec doctor --json` | passed | 6/6 items valid, repository healthy |
| Diff | `git diff --check` во всех трёх worktree | passed | whitespace errors отсутствуют |

Проверки и smoke выполнены 2026-07-13 по московскому времени. Live-вызовы HeadHunter не выполнялись.

## Безопасность

- Секреты и токены: runtime service key находится только в ignored `.env`; его значение отсутствует в tracked-файлах, выводе smoke и отчёте. Tracked env содержит только placeholder.
- Персональные данные: в отчёте нет UUID, cookie, паролей, токенов и содержимого HH-аккаунтов.
- Auth/permissions: существование пользователя проверяется в БД `main-be`; Bearer не откатывается к cookie; `X-User-Id` без Bearer отклоняется.
- Внешние ошибки и логи: проверенные ответы не раскрывают причину service-auth отказа; связанные логи не содержат ошибок или секретов.

## Риски и test gaps

- Live HH OAuth не запускался, потому что изменение не затрагивает контракт HH API и обычные проверки запрещают live-вызовы; OAuth transport покрыт mock-тестами.
- Фоновые процессы не изменялись, поэтому e2e фоновой операции неприменим.

## Rework checklist

### Backend

- [x] Доработка не требуется.

### Frontend

- [x] Доработка не требуется.

### Quality Gate

- [x] Независимая проверка завершена.
