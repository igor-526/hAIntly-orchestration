#!/usr/bin/env sh

set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
compose_file="$project_root/.docker-compose/docker-compose.fe.yml"
env_file="$project_root/services/main-fe/.env"

resolved_config=$(PORT=3101 docker compose --env-file "$env_file" -f "$compose_file" config)

if ! printf '%s\n' "$resolved_config" | grep -F -- 'target: 3101' >/dev/null ||
   ! printf '%s\n' "$resolved_config" | grep -F -- 'published: "3101"' >/dev/null; then
    printf '%s\n' 'Frontend Compose check failed: expected host/container port mapping 3101:3101.' >&2
    exit 1
fi

if ! printf '%s\n' "$resolved_config" | grep -F -- 'PORT: "3101"' >/dev/null; then
    printf '%s\n' 'Frontend Compose check failed: expected runtime PORT=3101.' >&2
    exit 1
fi

printf '%s\n' 'Frontend Compose configuration is valid with PORT=3101 and mapping 3101:3101.'
