# HAIntly Orchestrator

HAIntly помогает пользователю подключить HeadHunter, выбрать резюме, собрать подходящие вакансии, оценить их релевантность с помощью AI и подготовить сопроводительные письма.

Этот репозиторий — корень оркестратора. Продуктовые сервисы размещаются в отдельных Git-репозиториях внутри `services/`. На текущем этапе сервисы являются архитектурными заготовками без реализации.

## Сервисы

| Сервис | Назначение |
|---|---|
| `main-fe` | Next.js интерфейс |
| `main-be` | Пользователи, auth, API gateway и SSE |
| `profile-service` | HH OAuth, токены и резюме |
| `vacancy-service` | Сбор вакансий и пользовательские статусы |
| `ai-service` | Оценка релевантности и сопроводительные письма |
| `notification-service` | История, настройки и доставка уведомлений |

Подробные границы и связи описаны в [SERVICES.md](SERVICES.md).

## Структура

```text
.
├── AGENTS.md              # правила Router
├── agents/                # профили Backend, Frontend и Quality Gate
├── docs/
│   ├── information.md     # продуктовое описание
│   ├── prompts/           # входные ТЗ, когда появятся
│   └── reports/           # шаблон отчёта Quality Gate
├── openspec/
│   ├── config.yaml        # контекст и правила артефактов
│   ├── changes/           # активные changes, когда появятся
│   └── specs/             # синхронизированные требования
├── services/              # отдельные сервисные репозитории
└── services.manifest      # подключаемые репозитории
```

## Процесс разработки

```text
ТЗ или docs/prompts/<slug>.md
        ↓
OpenSpec propose
        ↓
Ревью proposal / design / specs / tasks человеком
        ↓
OpenSpec apply
        ↓
Backend и/или Frontend Agent
        ↓
Quality Gate
        ↓
rework либо sync + archive
```

OpenSpec change — единственный источник планирования продуктового изменения. Профильные агенты реализуют его задачи, а независимый Quality Gate проверяет результат.

Примеры запросов оркестратору:

```text
Создай OpenSpec change по docs/prompts/hh-oauth.md
Примени OpenSpec change add-hh-oauth
Проведи Quality Gate для add-hh-oauth
Архивируй OpenSpec change add-hh-oauth
```

Все смысловые части артефактов пишутся на русском языке. Английские структурные маркеры OpenSpec сохраняются, поскольку используются CLI-парсером.

## Синхронизация сервисов

Подключённые репозитории перечислены в `services.manifest`.

```bash
make sync
make services-branches
```

`make sync` выполняет сетевые Git-операции для записей manifest. Перед запуском убедитесь, что локальные изменения сервисов сохранены и доступны SSH-ключи.

`notification-service` пока создан локально и не добавлен в manifest.

## Текущий статус

- Архитектурные границы и процесс оркестрации описаны.
- Реализация сервисов ещё не начата.
- Унаследованные `Makefile`, compose-файлы и корневой `pyproject.toml` содержат остатки прежнего проекта и не являются рабочим способом запуска HAIntly.
- Runtime-конфигурация, endpoint, события, порты и команды сервисов будут определяться отдельными OpenSpec changes.

Не используйте `make up`, `make be`, `make fe` и связанные compose-команды до отдельной актуализации runtime-конфигурации.
