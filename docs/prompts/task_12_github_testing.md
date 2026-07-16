# Контекст
Некоторые тесты хорошо проходят в локальном окружении, но не проходят в github actions
Необходимо реализовать тесты всех сервисов таким образом, чтобы они выполнялись полностью локально и не выполнялись те, что требуют инфраструкутуру на GitHub Actions
# Ошибки
## Main Backend
```plaintext
Run make test

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:9)uv run pytest

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:10)============================= test session starts ==============================

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:11)platform linux -- Python 3.14.6, pytest-9.1.1, pluggy-1.6.0

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:12)rootdir: /home/runner/work/hAIntly-main-be/hAIntly-main-be

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:13)configfile: pyproject.toml

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:14)testpaths: tests

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:15)plugins: asyncio-1.4.0, anyio-4.14.1

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:16)asyncio: mode=Mode.AUTO, debug=False, asyncio_default_fixture_loop_scope=None, asyncio_default_test_loop_scope=function

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:17)collected 87 items

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:18)tests/api/test_auth.py .............. [ 16%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:19)tests/api/test_filters.py .............. [ 32%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:20)tests/api/test_hh_accounts.py .. [ 34%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:21)tests/api/test_vacancies.py ............ [ 48%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:22)tests/integration/test_dictionary_proxy_routes.py .. [ 50%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:23)tests/integration/test_oauth_state_repository.py sss [ 54%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:25)tests/integration/test_profile_service_smoke.py F [ 55%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:26)tests/integration/test_vacancy_proxy_http.py ..... [ 60%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:27)tests/unit/test_auth_service.py ...... [ 67%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:28)tests/unit/test_hh_accounts_service.py .. [ 70%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:29)tests/unit/test_hh_model_migration.py . [ 71%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:30)tests/unit/test_oauth_state.py ... [ 74%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:31)tests/unit/test_profile_service_transport.py .. [ 77%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:32)tests/unit/test_roles.py .. [ 79%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:33)tests/unit/test_settings.py ........ [ 88%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:34)tests/unit/test_vacancy_service_transport.py .......... [100%]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:35)=================================== FAILURES ===================================

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:36)___________ test_main_be_client_to_real_profile_routes_with_mock_hh ____________

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:37)@pytest.mark.asyncio

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:38)async def test_main_be_client_to_real_profile_routes_with_mock_hh() -> None:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:39)profile_root = Path(__file__).parents[3] / "profile-service"

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:40)with socket.socket() as probe:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:41)probe.bind(("127.0.0.1", 0))

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:42)port = probe.getsockname()[1]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:43)env = os.environ | {

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:44)"PYTHONPATH": "src:tests",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:45)"HH_TOKEN_ENCRYPT_KEY": "MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDA=",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:46)"HH_REDIRECT_URL": "http://localhost/callback",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:47)"HH_CLIENT_ID": "mock",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:48)"HH_CLIENT_SECRET": "mock",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:49)}

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:50)command = [

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:51)str(profile_root / ".venv/bin/python"),

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:52)"-m",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:53)"uvicorn",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:54)"mock_hh_app:app",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:55)"--host",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:56)"127.0.0.1",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:57)"--port",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:58)str(port),

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:59)"--log-level",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:60)"error",

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:61)]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:62)> process = await asyncio.create_subprocess_exec(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:63)*command,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:64)cwd=profile_root,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:65)env=env,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:66)stdout=asyncio.subprocess.DEVNULL,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:67)stderr=asyncio.subprocess.DEVNULL,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:68))

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:69)tests/integration/test_profile_service_smoke.py:38:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:70)_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:71)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/asyncio/subprocess.py:224: in create_subprocess_exec

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:72)transport, protocol = await loop.subprocess_exec(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:73)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/asyncio/base_events.py:1808: in subprocess_exec

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:74)transport = await self._make_subprocess_transport(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:75)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/asyncio/unix_events.py:203: in _make_subprocess_transport

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:76)transp = _UnixSubprocessTransport(self, protocol, args, shell,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:77)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/asyncio/base_subprocess.py:40: in __init__

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:78)self._start(args=args, shell=shell, stdin=stdin, stdout=stdout,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:79)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/asyncio/unix_events.py:845: in _start

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:80)self._proc = subprocess.Popen(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:81)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/subprocess.py:1039: in __init__

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:82)self._execute_child(args, executable, preexec_fn, close_fds,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:83)_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:84)self = <Popen: returncode: 255 args: ('/home/runner/work/hAIntly-main-be/profile-se...>

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:85)args = ['/home/runner/work/hAIntly-main-be/profile-service/.venv/bin/python', '-m', 'uvicorn', 'mock_hh_app:app', '--host', '127.0.0.1', ...]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:86)executable = b'/home/runner/work/hAIntly-main-be/profile-service/.venv/bin/python'

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:87)preexec_fn = None, close_fds = True, pass_fds = ()

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:88)cwd = PosixPath('/home/runner/work/hAIntly-main-be/profile-service')

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:89)env = {'ACCEPT_EULA': 'Y', 'ACTIONS_ORCHESTRATION_ID': 'b95a3511-e4d6-4756-9e2d-ca8e84a83378.test.__default', 'ACTIONS_RUNNER_ACTION_ARCHIVE_CACHE': '/opt/actionarchivecache', 'ACTIONS_RUNNER_RETURN_JOB_RESULT_FOR_HOSTED': '1', ...}

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:90)startupinfo = None, creationflags = 0, shell = False, p2cread = -1

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:91)p2cwrite = -1, c2pread = -1, c2pwrite = 15, errread = -1, errwrite = 15

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:92)restore_signals = True, gid = None, gids = None, uid = None, umask = -1

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:93)start_new_session = False, process_group = -1

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:94)def _execute_child(self, args, executable, preexec_fn, close_fds,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:95)pass_fds, cwd, env,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:96)startupinfo, creationflags, shell,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:97)p2cread, p2cwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:98)c2pread, c2pwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:99)errread, errwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:100)restore_signals,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:101)gid, gids, uid, umask,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:102)start_new_session, process_group):

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:103)"""Execute program (POSIX version)"""

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:104)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:105)if isinstance(args, (str, bytes)):

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:106)args = [args]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:107)elif isinstance(args, os.PathLike):

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:108)if shell:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:109)raise TypeError('path-like args is not allowed when '

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:110)'shell is true')

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:111)args = [args]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:112)else:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:113)args = list(args)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:114)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:115)if shell:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:116)# On Android the default shell is at '/system/bin/sh'.

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:117)unix_shell = ('/system/bin/sh' if

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:118)hasattr(sys, 'getandroidapilevel') else '/bin/sh')

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:119)args = [unix_shell, "-c"] + args

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:120)if executable:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:121)args[0] = executable

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:122)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:123)if executable is None:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:124)executable = args[0]

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:125)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:126)sys.audit("subprocess.Popen", executable, args, cwd, env)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:127)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:128)if (_USE_POSIX_SPAWN

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:129)and os.path.dirname(executable)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:130)and preexec_fn is None

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:136)and (not close_fds or _HAVE_POSIX_SPAWN_CLOSEFROM)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:137)and not pass_fds

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:138)and cwd is None

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:139)and (p2cread == -1 or p2cread > 2)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:140)and (c2pwrite == -1 or c2pwrite > 2)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:141)and (errwrite == -1 or errwrite > 2)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:142)and not start_new_session

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:143)and process_group == -1

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:144)and gid is None

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:145)and gids is None

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:146)and uid is None

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:147)and umask < 0):

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:148)self._posix_spawn(args, executable, env, restore_signals, close_fds,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:149)p2cread, p2cwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:150)c2pread, c2pwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:151)errread, errwrite)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:152)return

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:153)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:154)orig_executable = executable

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:155)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:156)# For transferring possible exec failure from child to parent.

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:157)# Data format: "exception name:hex errno:description"

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:158)# Pickle is not used; it is complex and involves memory allocation.

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:159)errpipe_read, errpipe_write = os.pipe()

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:160)# errpipe_write must not be in the standard io 0, 1, or 2 fd range.

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:161)low_fds_to_close = []

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:162)while errpipe_write < 3:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:163)low_fds_to_close.append(errpipe_write)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:164)errpipe_write = os.dup(errpipe_write)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:165)for low_fd in low_fds_to_close:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:166)os.close(low_fd)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:167)try:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:168)try:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:169)# We must avoid complex work that could involve

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:170)# malloc or free in the child process to avoid

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:171)# potential deadlocks, thus we do all this here.

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:172)# and pass it to fork_exec()

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:173)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:174)if env is not None:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:175)env_list = []

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:176)for k, v in env.items():

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:177)k = os.fsencode(k)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:178)if b'=' in k:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:179)raise ValueError("illegal environment variable name")

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:180)env_list.append(k + b'=' + os.fsencode(v))

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:181)else:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:182)env_list = None # Use execv instead of execve.

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:183)executable = os.fsencode(executable)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:184)if os.path.dirname(executable):

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:185)executable_list = (executable,)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:186)else:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:187)# This matches the behavior of os._execvpe().

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:188)executable_list = tuple(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:189)os.path.join(os.fsencode(dir), executable)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:190)for dir in os.get_exec_path(env))

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:191)fds_to_keep = set(pass_fds)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:192)fds_to_keep.add(errpipe_write)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:193)self.pid = _fork_exec(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:194)args, executable_list,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:195)close_fds, tuple(sorted(map(int, fds_to_keep))),

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:196)cwd, env_list,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:197)p2cread, p2cwrite, c2pread, c2pwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:198)errread, errwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:199)errpipe_read, errpipe_write,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:200)restore_signals, start_new_session,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:201)process_group, gid, gids, uid, umask,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:202)preexec_fn)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:203)self._child_created = True

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:204)finally:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:205)# be sure the FD is closed no matter what

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:206)os.close(errpipe_write)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:207)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:208)self._close_pipe_fds(p2cread, p2cwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:209)c2pread, c2pwrite,

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:210)errread, errwrite)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:211)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:212)# Wait for exec to fail or succeed; possibly raising an

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:213)# exception (limited in size)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:214)errpipe_data = bytearray()

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:215)while True:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:216)part = os.read(errpipe_read, 50000)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:217)errpipe_data += part

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:218)if not part or len(errpipe_data) > 50000:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:219)break

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:220)finally:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:221)# be sure the FD is closed no matter what

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:222)os.close(errpipe_read)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:223)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:224)if errpipe_data:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:225)try:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:226)pid, sts = os.waitpid(self.pid, 0)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:227)if pid == self.pid:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:228)self._handle_exitstatus(sts)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:229)else:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:230)self.returncode = sys.maxsize

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:231)except ChildProcessError:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:232)pass

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:233)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:234)try:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:235)exception_name, hex_errno, err_msg = (

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:236)errpipe_data.split(b':', 2))

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:237)# The encoding here should match the encoding

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:238)# written in by the subprocess implementations

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:239)# like _posixsubprocess

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:240)err_msg = err_msg.decode()

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:241)except ValueError:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:242)exception_name = b'SubprocessError'

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:243)hex_errno = b'0'

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:244)err_msg = 'Bad exception data from child: {!r}'.format(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:245)bytes(errpipe_data))

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:246)child_exception_type = getattr(

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:247)builtins, exception_name.decode('ascii'),

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:248)SubprocessError)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:249)if issubclass(child_exception_type, OSError) and hex_errno:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:250)errno_num = int(hex_errno, 16)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:251)if err_msg == "noexec:chdir":

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:252)err_msg = ""

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:253)# The error must be from chdir(cwd).

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:254)err_filename = cwd

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:255)elif err_msg == "noexec":

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:256)err_msg = ""

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:257)err_filename = None

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:258)else:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:259)err_filename = orig_executable

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:260)if errno_num != 0:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:261)err_msg = os.strerror(errno_num)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:262)if err_filename is not None:

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:263)> raise child_exception_type(errno_num, err_msg, err_filename)

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:264)E FileNotFoundError: [Errno 2] No such file or directory: PosixPath('/home/runner/work/hAIntly-main-be/profile-service')

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:265)../../_temp/uv-python-dir/cpython-3.14.6-linux-x86_64-gnu/lib/python3.14/subprocess.py:1990: FileNotFoundError

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:266)=========================== short test summary info ============================

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:267)FAILED tests/integration/test_profile_service_smoke.py::test_main_be_client_to_real_profile_routes_with_mock_hh - FileNotFoundError: [Errno 2] No such file or directory: PosixPath('/home/runner/work/hAIntly-main-be/profile-service')

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:268)=================== 1 failed, 83 passed, 3 skipped in 2.95s ====================

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:270)make: *** [Makefile:13: test] Error 1

[](https://github.com/igor-526/hAIntly-main-be/actions/runs/29475926912/job/87548759779#step:6:271)Error: Process completed with exit code 2. 
```
## Vacancy Service
```plaintext
Run make test

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:2)make test

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:3)shell: /usr/bin/bash -e {0}

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:4)env:

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:5)UV_PYTHON_INSTALL_DIR: /home/runner/work/_temp/uv-python-dir

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:6)UV_CACHE_DIR: /home/runner/work/_temp/setup-uv-cache

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:8)Поднимите тестовую инфраструктуру командой: make infra

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:9)make: *** [Makefile:13: test] Error 1

[](https://github.com/igor-526/hAIntly-vacancy-service/actions/runs/29486458974/job/87581996204#step:6:10)Error: Process completed with exit code 2.
```