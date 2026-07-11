# =====VARIABLES=====
COMPOSE_DIR = .docker-compose
SERVICES_MANIFEST ?= services.manifest

# =====COMPOSE FILES=====
COMPOSE_INFRA = $(COMPOSE_DIR)/docker-compose.infra.yml
COMPOSE_BE = $(COMPOSE_DIR)/docker-compose.be.yml
COMPOSE_FE = $(COMPOSE_DIR)/docker-compose.fe.yml

DC_INFRA := docker compose -f $(COMPOSE_INFRA)
DC_BE := docker compose -f $(COMPOSE_BE)
DC_FE := docker compose --env-file services/main-fe/.env -f $(COMPOSE_FE)

#=====ORCHESTRATOR COMMANDS=====
sync:
	@echo "Syncing all services..."
	@bash scripts/sync.sh

services-branches:
	@echo "=== Git branches (services) ==="
	@echo ""
	@printf "%-28s %-36s %s\n" "PATH" "BRANCH" "WORKTREE"
	@printf "%-28s %-36s %s\n" "----------------------------" "------------------------------------" "----------"
	@if [ -d .git ]; then \
		br=$$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?"); \
		if [ "$$br" = "HEAD" ]; then br="detached @$$(git rev-parse --short HEAD 2>/dev/null)"; fi; \
		n=$$(git status --porcelain 2>/dev/null | wc -l | tr -d ' '); \
		[ "$$n" = "0" ] && wt=clean || wt="dirty ($$n files)"; \
		printf "%-28s %-36s %s\n" "orchestration (monorepo root)" "$$br" "$$wt"; \
	else \
		printf "%-28s %-36s %s\n" "orchestration (monorepo root)" "(not a git repo)" "-"; \
	fi
	@while IFS= read -r line || [ -n "$$line" ]; do \
		case "$$line" in ""|\#*) continue ;; esac; \
		svc=$${line%%[[:space:]]*}; \
		[ -z "$$svc" ] && continue; \
		dir="services/$$svc"; \
		if [ ! -d "$$dir" ]; then \
			printf "%-28s %-36s %s\n" "$$dir" "(directory missing)" "-"; \
			continue; \
		fi; \
		if [ ! -e "$$dir/.git" ]; then \
			printf "%-28s %-36s %s\n" "$$dir" "(not a git clone)" "-"; \
			continue; \
		fi; \
		br=$$(git -C "$$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?"); \
		if [ "$$br" = "HEAD" ]; then br="detached @$$(git -C "$$dir" rev-parse --short HEAD 2>/dev/null)"; fi; \
		n=$$(git -C "$$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' '); \
		[ "$$n" = "0" ] && wt=clean || wt="dirty ($$n files)"; \
		printf "%-28s %-36s %s\n" "$$dir" "$$br" "$$wt"; \
	done < $(SERVICES_MANIFEST)
	@echo ""
	@echo "Source list: $(SERVICES_MANIFEST)"

%:
	@:

#=====BUILD COMMANDS=====
be-build:
	@echo "Building backend image..."
	@docker compose -f $(COMPOSE_BE) build

fe-build:
	@echo "Building frontend image..."
	@$(DC_FE) build

check-compose-fe:
	@./scripts/check-compose-fe.sh

check-compose-infra:
	@sh scripts/check-compose-infra.sh

#=====RUN COMMANDS=====
infra:
	$(DC_INFRA) up -d

be:
	$(DC_BE) up -d

fe:
	$(DC_FE) up -d
