#!/usr/bin/env sh

set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
compose_file="$project_root/.docker-compose/docker-compose.infra.yml"
env_file="$project_root/.docker-compose/.env"

resolved_config=$(docker compose --env-file "$env_file" -f "$compose_file" config)
expected_healthcheck='pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}'

if ! printf '%s\n' "$resolved_config" | grep -F -- "$expected_healthcheck" >/dev/null; then
    printf '%s\n' 'Infra Compose check failed: PostgreSQL healthcheck does not use POSTGRES_USER and POSTGRES_DB.' >&2
    exit 1
fi

printf '%s\n' 'Infra Compose configuration is valid and PostgreSQL healthcheck is correct.'
