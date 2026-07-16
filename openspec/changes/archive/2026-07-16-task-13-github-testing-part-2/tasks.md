## 1. Backend

### vacancy-service

- [x] 1.1 Добавить в test harness безопасные обязательные test-only значения до импорта application settings, сохранив приоритет заранее заданного infrastructure environment и строгую runtime-валидацию `Settings`.
- [x] 1.2 Добавить автоматизированную регрессионную проверку import/collection автономного pytest-набора в очищенном окружении без `vacancy-service/.env`, runtime secrets и внешних соединений.
- [x] 1.3 Выполнить `make format`, `make lint` и `make test`, отдельно подтвердив успешный автономный запуск без service `.env` и обязательных runtime-переменных; при доступной локальной инфраструктуре выполнить `make test-infra`.
- [x] 1.4 Собрать образ `vacancy-service` без запуска, поднять сервис предусмотренным compose-процессом, проверить health/readiness и логи либо документированно подтвердить, что test-only diff не изменяет container/runtime context.

## 2. Quality Gate

- [x] 2.1 Проверить diff на соответствие proposal, design и delta spec, включая отсутствие test defaults в production-коде, сохранение marker-классификации и приоритета infrastructure credentials.
- [x] 2.2 Независимо выполнить `make format`, `make lint`, `make test` для `vacancy-service` и регрессионный запуск в очищенном окружении без `.env`, secrets, Docker, PostgreSQL и Redis.
- [x] 2.3 Выполнить применимый `make test-infra`, проверить сборку/запуск контейнера, health/readiness и логи `vacancy-service`; если infrastructure или runtime-проверка неприменима к test-only diff, зафиксировать обоснование и доступные доказательства.
- [x] 2.4 Вернуть итог `ОДОБРЕНО` или `НА ДОРАБОТКУ`; после успешной проверки создать отчёт в `docs/reports` по `docs/reports/TEMPLATE.md`.
