## Why

Пользователь HAIntly может сохранять пресеты фильтров (task-08) и имеет локальные справочники HH (task-07), но не может искать и просматривать вакансии. Система фильтрации вакансий — следующий шаг пайплайна: передать параметры поиска в HH API, отобразить список и показать детали выбранной вакансии.

## What Changes

- `vacancy-service` получает два новых internal endpoint: `GET /internal/vacancies` (поиск по HH API с параметрами фильтров) и `GET /internal/vacancies/{vacancy_id}` (получение деталей одной вакансии).
- В `vacancy-service` добавляется сервисный endpoint `GET /internal/hh-token` для передачи актуального access token другим сервисам (с поддержкой refresh).
- `profile-service` получает сервисный endpoint `GET /internal/hh-token/{account_id}` для выдачи расшифрованного access token с опциональным refresh.
- `main-be` добавляет proxy-endpoints `GET /api/vacancies` и `GET /api/vacancies/{vacancy_id}` с cookie-auth, передачей контекста и проксированием к `vacancy-service`.
- `main-fe` реализует рабочую область «список вакансий слева + детали справа»: загрузка вакансий при открытии, отображение карточек, показ деталей по клику. Кнопка «Применить» в Drawer фильтров теперь запускает поиск.

## Capabilities

### New Capabilities
- `vacancy-search-api`: внутренний API поиска вакансий через HH API с поддержкой всех не-deprecated параметров фильтров и пресетов, а также получение деталей одной вакансии.
- `vacancy-search-proxy`: проксирование поиска и просмотра вакансий через main-be с cookie-auth.
- `hh-token-service`: сервисный endpoint передачи расшифрованного HH access token между сервисами с поддержкой refresh.
- `vacancy-search-ui`: рабочая область поиска вакансий в main-fe — список слева, детали справа, интеграция с Drawer фильтров.

### Modified Capabilities
- `filter-preset-ui`: кнопка «Применить» в Drawer фильтров перестаёт быть заглушкой и запускает поиск вакансий.

## Impact

| Сервис | Что затронуто |
|---|---|
| `profile-service` | Новый internal endpoint для выдачи access token с refresh; расширение `HHAccountService`. |
| `vacancy-service` | Новый HH-клиент метод `search_vacancies` и `get_vacancy`; два internal router endpoints; схемы запросов/ответов; зависимость от profile-service для получения токена. |
| `main-be` | Новый proxy router `vacancies.py`; расширение `VacancyServiceClient`; передача HH token от profile-service. |
| `main-fe` | Новый feature `vacancy-search/` (workspace, vacancy list, vacancy detail, хуки, сервисы); интеграция с FilterDrawer; обновление workspace layout. |
