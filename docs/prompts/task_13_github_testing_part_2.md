# Контекст
Продолжаем задачу `prompts/task_12_github_testing`
Такая ошибка возникает в `vacancy-service`
# Ошибка
```plaintext
Run make test

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:9)uv run pytest -m "not infrastructure"

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:10)ImportError while loading conftest '/home/runner/work/hAIntly-vacancy-service/hAIntly-vacancy-service/tests/conftest.py'.

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:11)tests/conftest.py:18: in <module>

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:12)from settings import settings

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:13)src/settings.py:54: in <module>

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:14)settings = Settings() # type: ignore[call-arg]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:15)^^^^^^^^^^

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:16).venv/lib/python3.14/site-packages/pydantic_settings/main.py:247: in __init__

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:17)super().__init__(**__pydantic_self__.__class__._settings_build_values(sources, init_kwargs))

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:18)E pydantic_core._pydantic_core.ValidationError: 8 validation errors for Settings

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:19)E HH_APP_TOKEN

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:20)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:21)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:22)E HH_API_URL

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:23)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:24)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:25)E HH_USER_AGENT

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:26)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:27)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:28)E CELERY_BROKER_URL

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:29)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:30)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:31)E CELERY_RESULT_BACKEND

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:32)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:33)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:34)E DICTIONARY_LOCK_URL

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:35)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:36)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:37)E VACANCY_DICTIONARY_MAX_AGE_HOURS

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:38)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:39)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:40)E PROFILE_SERVICE_URL

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:41)E Field required [type=missing, input_value={}, input_type=dict]

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:42)E For further information visit [https://errors.pydantic.dev/2.13/v/missing](https://errors.pydantic.dev/2.13/v/missing)

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29499494042/job/87624527448#step:6:43)make: *** [Makefile:13: test] Error 4
```