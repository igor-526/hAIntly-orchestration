## Why

После внедрения автономного `make test` в `vacancy-service` GitHub Actions всё ещё падает до сбора тестов: общий `tests/conftest.py` импортирует глобальный экземпляр `Settings`, а обязательные runtime-параметры HH, Celery, Redis и `profile-service` отсутствуют в отдельном CI checkout. Автономный тестовый контракт должен распространяться не только на исполняемые тесты, но и на их импорт и collection, при этом production-конфигурация обязана оставаться строгой.

## What Changes

- Обеспечить `vacancy-service` явной безопасной test-конфигурацией для автономного pytest pipeline, чтобы `make test` собирал и запускал тесты без `.env`, secrets и внешней инфраструктуры.
- Устранить загрузку обязательной production-конфигурации общим `conftest.py` до того, как тестовое окружение подготовлено, сохранив доступ infrastructure fixtures для `make test-infra`.
- Зафиксировать минимальный набор не секретных test-only значений для HH URL/token/user-agent, Celery broker/backend, Redis lock, возраста словарей и адреса `profile-service`; значения не должны инициировать реальные внешние обращения в автономном наборе.
- Сохранить fail-fast валидацию обязательных параметров при обычном запуске приложения и фоновых процессов: production/runtime defaults для внешних контрактов не добавляются.
- Добавить регрессионную проверку, воспроизводящую запуск `make test` в окружении без сервисного `.env` и без перечисленных runtime-переменных.
- Не изменять продуктовые API, схемы БД, миграции, события, фоновые алгоритмы, HeadHunter-контракты и GitHub Actions workflow.

## Capabilities

### New Capabilities

Нет.

### Modified Capabilities

- `service-quality-commands`: автономный backend test pipeline обязан успешно проходить pytest collection без runtime secrets и внешних настроек, используя явную безопасную test-конфигурацию и не ослабляя валидацию конфигурации приложения вне тестов.

## Impact

- `vacancy-service`: `tests/conftest.py`, test configuration/fixtures и регрессионные тесты автономного запуска; при необходимости — тестовая команда или вспомогательный test-only файл окружения.
- `service-quality-commands`: уточнение действующего контракта автономного `make test` для стадии import/collection и требований к разделению test/runtime configuration.
- GitHub Actions `vacancy-service`: существующая команда `make test` начинает выполняться в отдельном checkout без repository secrets и service containers; сам workflow менять не требуется.
- Runtime-код, зависимости, публичные и межсервисные контракты не меняются; обязательные значения `Settings` остаются обязательными при запуске сервиса.
