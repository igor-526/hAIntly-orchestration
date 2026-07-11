# Контекст
Нам нужно навести порядок в docker compose файлах
Они расположены в папке `.cocker-compose`
# Issue 1. Frontend deprecated
При сборке основного frontend у меня выходят следующие предупреждения:
```plaintext
npm warn deprecated [whatwg-encoding@3.1.1](mailto:whatwg-encoding@3.1.1): Use @exodus/bytes instead for a more spec-conformant and faster implementation
```
и
```
npm notice  
npm notice New major version of npm available! 10.9.8 -> 12.0.1  
npm notice Changelog: [https://github.com/npm/cli/releases/tag/v12.0.1](https://github.com/npm/cli/releases/tag/v12.0.1)  
npm notice To update run: npm install -g [npm@12.0.1](mailto:npm@12.0.1)  
npm notice
```
Давай обновим всё, что возможно и избавимся от deprecated
# Issue 2. Backend db
База данных поднимается compose файлом infra. Там какая-то проблема с healthcheck
На данный момент работает контейнер `a4bda1130ae5` в статусе unhealthy. Нужно исправить проблему с healthcheck
# Issue 3. Frontend image prots
Фронтенд поднимается командой `make fe`.  Там какие-то проблемы с портами. Мне нужно, чтобы образ открывал тот порт, который в переменной в `.env`, а `docker-compose` прокидывал эти же порты на локальную машину. Например, тут мне нужно поднятие на 3101