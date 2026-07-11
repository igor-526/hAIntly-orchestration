## 1. Backend

### main-be

- [x] 1.1 Исправить PostgreSQL healthcheck в `.docker-compose/docker-compose.infra.yml`, чтобы `pg_isready` использовал корректные container environment variables `POSTGRES_USER` и `POSTGRES_DB`.
- [x] 1.2 Добавить автоматическую статическую проверку разрешённой infra Compose-конфигурации и команды PostgreSQL healthcheck.

## 2. Frontend

### main-fe

- [x] 2.1 Обновить совместимые зависимости `main-fe` и `package-lock.json`, подтвердив отсутствие `whatwg-encoding` в разрешённом npm-дереве.
- [x] 2.2 Перевести Dockerfile `main-fe` на воспроизводимую установку по lock-файлу и отключить npm major-version notice без глобального обновления npm.
- [x] 2.3 Согласовать `PORT` в `services/main-fe/.env`, `.docker-compose/docker-compose.fe.yml`, Dockerfile и корневом `Makefile`, чтобы process, exposed container port и host port совпадали.
- [x] 2.4 Добавить автоматическую статическую проверку frontend Compose-конфигурации, подтверждающую сопоставление `3101:3101` при `PORT=3101`.
- [x] 2.5 Выполнить frontend unit-тесты, lint и production build после обновления зависимостей и контейнерной конфигурации.

## 3. Quality Gate

- [x] 3.1 Проверить diff на соответствие proposal, design, spec `local-compose-runtime`, границам сервисов и отсутствие изменений HTTP/SSE/NATS/БД-контрактов.
- [x] 3.2 Выполнить статические проверки Compose и доступные frontend-проверки, отдельно зафиксировав недоступные проверки при отсутствии Docker daemon.
- [x] 3.3 При доступном Docker daemon собрать и запустить frontend с `PORT=3101`, поднять infra и подтвердить доступность frontend и состояние PostgreSQL `healthy`.
- [x] 3.4 Вернуть итоговый вердикт `ОДОБРЕНО` или `НА ДОРАБОТКУ` с атомарными замечаниями.
