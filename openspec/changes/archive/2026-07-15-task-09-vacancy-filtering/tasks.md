## 1. Backend

### profile-service

- [x] 1.1 Добавить метод `refresh_token(refresh_token: str)` в `AiohttpHHClient`, выполняющий `POST /oauth/token` к HH API с `grant_type=refresh_token` и возвращающий `HHTokens`
- [x] 1.2 Добавить метод `get_access_token(account_id, user_id, refresh=False)` в `HHAccountService`, загружающий аккаунт, при необходимости вызывающий refresh и возвращающий расшифрованный access_token и expires_at
- [x] 1.3 Добавить endpoint `GET /internal/hh-token/{account_id}` с query-параметром `refresh` в router `hh_accounts.py`, возвращающий `{"access_token": "...", "expires_at": "..."}`
- [x] 1.4 Написать unit-тесты для метода refresh_token и get_access_token (успешный refresh, не требуется refresh, invalid_grant, другая ошибка)
- [x] 1.5 Написать интеграционные тесты для endpoint `GET /internal/hh-token/{account_id}` (успешный ответ, refresh failed 401, 404 чужой аккаунт, отсутствие X-User-Id)
- [x] 1.6 Собрать образ profile-service, поднять контейнеры, проверить health и логи

### vacancy-service

- [x] 1.7 Добавить HTTP-клиент profile-service в `src/infrastructure/profile_service.py` с методом `get_hh_token(account_id, refresh=True)`, возвращающим access_token
- [x] 1.8 Добавить метод `search_vacancies(params: dict, access_token: str)` в `HHClient`, выполняющий `GET /vacancies` к HH API с Bearer token
- [x] 1.9 Добавить метод `get_vacancy(vacancy_id: str, access_token: str)` в `HHClient`, выполняющий `GET /vacancies/{id}` к HH API с Bearer token
- [x] 1.10 Добавить настройки `PROFILE_SERVICE_URL` и `PROFILE_SERVICE_TIMEOUT_SECONDS` в `settings.py`
- [x] 1.11 Создать Pydantic-схемы (request/response) для поиска вакансий в `src/core/schemas/vacancies.py`
- [x] 1.12 Создать сервис `src/core/services/vacancies.py` с логикой: (1) получение токена от profile-service, (2) загрузка пресета при `preset_id`, (3) слияние параметров пресета и переданных параметров, (4) вызов HH API
- [x] 1.13 Создать router `src/api/vacancies.py` с endpoints `GET /internal/vacancies` и `GET /internal/vacancies/{vacancy_id}` в namespace `/internal/vacancies`
- [x] 1.14 Добавить валидацию заголовков `X-User-Id` и `X-Hh-Account-Id` в dependency для endpoints вакансий
- [x] 1.15 Подключить router в `src/main.py`
- [x] 1.16 Написать unit-тесты для сервиса вакансий (логика слияния параметров, обработка пресета, передача токена)
- [x] 1.17 Написать интеграционные тесты для API вакансий (поиск без фильтров, с параметрами, по пресету, с переопределением, 404 пресета, невалидные заголовки)
- [x] 1.18 Собрать образ vacancy-service, поднять контейнеры, проверить health и логи

### main-be

- [x] 1.19 Расширить `ProfileServiceClient` методом `get_selected_account(user_id)` для получения selected HH account (account_id, hh_user_id)
- [x] 1.20 Расширить `VacancyServiceClient` методами `vacancies_search(user_id, account_id, params)` и `vacancy_get(user_id, account_id, vacancy_id)`
- [x] 1.21 Создать router `src/api/vacancies.py` с proxy-endpoints `GET /api/vacancies` и `GET /api/vacancies/{vacancy_id}` в namespace `/api/vacancies`
- [x] 1.22 Подключить router в `src/main.py`
- [x] 1.23 Написать тесты для proxy-endpoints вакансий (cookie-auth, передача параметров, 401, 400 нет HH аккаунта, проксирование ошибок)
- [x] 1.24 Собрать образ main-be, поднять контейнеры, проверить health и логи

## 2. Frontend

### main-fe

- [x] 2.1 Создать `features/vacancies/types.ts` с TypeScript-типами для результатов поиска и деталей вакансий
- [x] 2.2 Создать `features/vacancies/service.ts` с методами `search(params)` и `get(vacancy_id)` через `apiRequest()`
- [x] 2.3 Создать `features/vacancies/use-vacancy-search.ts` хук с состоянием поиска (vacancies, selectedId, vacancy, loading, error, page, hasMore) и методами search/loadMore/select
- [x] 2.4 Создать `features/vacancies/vacancy-list.tsx` — список карточек вакансий в левой панели с infinite scroll (IntersectionObserver, sentinel-элемент, подгрузка при скролле до конца)
- [x] 2.5 Создать `features/vacancies/vacancy-card.tsx` — карточка вакансии (имя, работодатель, зарплата, локация, snippet)
- [x] 2.6 Создать `features/vacancies/vacancy-detail.tsx` — полная информация о вакансии в правой панели
- [x] 2.7 Обновить `features/hh-accounts/workspace.tsx`: заменить placeholder на VacancyList слева и VacancyDetail справа, интегрировать useVacancySearch
- [x] 2.8 Обновить `features/filters/filter-drawer.tsx`: подключить логику поиска к кнопке «Применить» (вызов search с параметрами формы, закрытие Drawer)
- [x] 2.9 Написать тесты для vacancy service, use-vacancy-search хука и ключевых компонентов
- [x] 2.10 Запустить dev-server, проверить загрузку вакансий, клик по карточке, применение фильтров в браузере

## 3. Quality Gate

- [x] 3.1 Проверить соответствие реализации спецификациям `hh-token-service`, `vacancy-search-api`, `vacancy-search-proxy`, `vacancy-search-ui`, `filter-preset-ui`
- [x] 3.2 Проверить smoke API profile-service: `GET /internal/hh-token/{account_id}` (успешный ответ, refresh failed)
- [x] 3.3 Проверить direct smoke vacancy-service: `GET /internal/vacancies` и `GET /internal/vacancies/{id}` (с валидными заголовками)
- [x] 3.4 Проверить proxy smoke через main-be: `GET /api/vacancies` и `GET /api/vacancies/{id}` (с cookie-auth)
- [x] 3.5 Проверить e2e: поиск без фильтров, с параметрами, по пресету, с переопределением, детали вакансии
- [x] 3.6 Проверить frontend: загрузка вакансий при открытии, клик по карточке, применение фильтров через Drawer
- [x] 3.7 Проверить логи всех затронутых контейнеров на наличие ошибок
- [x] 3.8 Создать отчёт в `docs/reports` по `docs/reports/TEMPLATE.md`
