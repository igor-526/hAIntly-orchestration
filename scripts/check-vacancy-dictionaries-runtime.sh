#!/bin/sh
set -eu

compose="docker compose -f .docker-compose/docker-compose.vacancy.yml"
psql="docker exec -i haintly-db-vacancy psql -U vacancy_user -d vacancy_db"
names="dictionaries areas countries professional_roles industries metro languages"

run_due() {
  $compose exec -T worker uv run --no-sync python -c \
    'from tasks import check_dictionaries; print(",".join(check_dictionaries.run()))'
}

wait_success() {
  name=$1
  for _ in $(seq 1 120); do
    state=$($psql -Atc "select status from dictionary_sync_states where name='$name'" 2>/dev/null || true)
    [ "$state" = success ] && return 0
    [ "$state" = failed ] && return 1
    sleep 1
  done
  return 1
}

curl -fsS http://localhost:8103/health >/dev/null
$psql -c "TRUNCATE metro_stations,metro_lines,metro_cities,professional_roles,professional_role_categories,industries,areas,countries,dictionary_items,languages,dictionary_sync_states RESTART IDENTITY CASCADE" >/dev/null
initial=$(run_due)
[ "$initial" = "dictionaries,areas,countries,professional_roles,industries,metro,languages" ]
for name in $names; do
  wait_success "$name"
done
for table in dictionary_items areas countries professional_role_categories professional_roles industries metro_cities metro_lines metro_stations languages; do
  [ "$($psql -Atc "select count(*) from $table")" -gt 0 ]
done

$psql -c "INSERT INTO languages(hh_id,name,active) VALUES('__e2e_removed__','Removed',true) ON CONFLICT(hh_id) DO UPDATE SET active=true; UPDATE languages SET name='Old',active=false WHERE hh_id='abq'; DELETE FROM dictionary_sync_states WHERE name='languages'" >/dev/null
[ "$(run_due)" = languages ]
wait_success languages
[ "$($psql -Atc "select active from languages where hh_id='__e2e_removed__'")" = f ]
[ "$($psql -Atc "select name||':'||active from languages where hh_id='abq'")" = "Абазинский:true" ]

$psql -c "UPDATE dictionary_sync_states SET status='stale',last_success_at=now()-interval '25 hours' WHERE name='areas'" >/dev/null
[ "$(run_due)" = areas ]
wait_success areas

before=$(docker exec haintly-redis sh -c 'redis-cli -a "$REDIS_PASSWORD" -n 2 LLEN celery' 2>/dev/null)
[ -z "$(run_due)" ]
after=$(docker exec haintly-redis sh -c 'redis-cli -a "$REDIS_PASSWORD" -n 2 LLEN celery' 2>/dev/null)
[ "$before" = "$after" ]

last_success=$($psql -Atc "select last_success_at from dictionary_sync_states where name='languages'")
$compose exec -T worker uv run --no-sync python - <<'PY' >/dev/null
import asyncio
import tasks
class Invalid:
    async def languages(self): return []
tasks._client=lambda: Invalid()
try: asyncio.run(tasks._sync("languages"))
except Exception: pass
PY
[ "$last_success" = "$($psql -Atc "select last_success_at from dictionary_sync_states where name='languages'")" ]
[ "$($psql -Atc "select status from dictionary_sync_states where name='languages'")" = failed ]
$psql -c "UPDATE dictionary_sync_states SET status='queued' WHERE name='languages'" >/dev/null
$compose exec -T worker uv run --no-sync celery -A tasks.celery_app call vacancy.sync_dictionary --args='["languages"]' >/dev/null
wait_success languages

echo "vacancy dictionaries deterministic runtime e2e: ok"
