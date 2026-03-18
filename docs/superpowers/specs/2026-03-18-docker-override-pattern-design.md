# Docker Override Pattern Refactor

## Context

Single-service Neovim dev container project. Currently uses a single `docker-compose.development.yml` with environment-specific directory nesting (`.docker/development/ubuntu/`).

## Goals

- Adopt the standard Docker Compose 3-layer override pattern
- Support per-developer local overrides (volume mounts) via gitignored file
- Simplify directory structure
- Fix pre-existing bugs found during refactor

## Design

### File Structure

```
docker-compose.yml              # base: service definition, build context, networks
docker-compose.override.yml     # dev defaults: restart policy, dev-specific config
docker-compose.local.yml        # per-developer volume mounts (gitignored)
.env                            # unchanged (APP_NAME=nvim-container)
.docker/ubuntu/Dockerfile       # simplified path (was .docker/development/ubuntu/)
.docker/ubuntu/start-container  # moves with Dockerfile
Makefile                        # updated commands
.gitignore                      # new file (repo has none currently)
```

### Layer Responsibilities

| Layer | File | Auto-loaded | Purpose |
|-------|------|-------------|---------|
| Base | `docker-compose.yml` | Yes | Service definition, build context, networks |
| Dev Override | `docker-compose.override.yml` | Yes | Dev-specific: restart policy |
| Local Override | `docker-compose.local.yml` | No (auto-detected by Makefile) | Per-developer: volume mounts |

### File Contents

**`docker-compose.yml`**

The `version` key from the old file is intentionally removed — it has been obsolete since Docker Compose V2 and now produces a warning.

```yaml
networks:
  network_app:
    driver: bridge

services:
  ubuntu:
    container_name: ${APP_NAME}_ubuntu
    hostname: ubuntu
    build:
      context: ./.docker/ubuntu
      dockerfile: Dockerfile
    networks:
      - network_app
```

**`docker-compose.override.yml`**
```yaml
services:
  ubuntu:
    restart: unless-stopped
```

**`docker-compose.local.yml`** (gitignored, created by each developer as needed)
```yaml
services:
  ubuntu:
    volumes:
      - ~/.ssh:/root/.ssh:ro
```

**Makefile**

Uses `wildcard` to auto-detect `docker-compose.local.yml` — no separate `_local` targets needed. Also fixes the pre-existing `-` prefix on the connect command (Make's "ignore errors" prefix, almost certainly unintentional).

```makefile
COMPOSE_FILES := -f docker-compose.yml -f docker-compose.override.yml
ifneq (,$(wildcard docker-compose.local.yml))
COMPOSE_FILES += -f docker-compose.local.yml
endif

dev_up:
	docker compose $(COMPOSE_FILES) up -d

dev_down:
	docker compose $(COMPOSE_FILES) down

dev_build:
	docker compose $(COMPOSE_FILES) build

dev_ubuntu_connect:
	docker compose $(COMPOSE_FILES) exec ubuntu bash
```

**`.gitignore`** (new file)
```
docker-compose.local.yml
```

### Files Removed

- `docker-compose.development.yml` — replaced by 3-layer pattern

### Files Moved

- `.docker/development/ubuntu/Dockerfile` -> `.docker/ubuntu/Dockerfile`
- `.docker/development/ubuntu/start-container` -> `.docker/ubuntu/start-container`

### Bug Fixes

- **`start-container` shebang**: `#!bin/bash` -> `#!/bin/bash` (missing `/`)
- **Makefile `-` prefix**: removed unintentional error-suppression prefix from connect command

### Dockerfile

No content changes. Only the directory location changes.

### start-container

Shebang fix only. No other content changes.

## Usage

- **Start**: `make dev_up`
- **Stop**: `make dev_down`
- **Rebuild**: `make dev_build`
- **Connect**: `make dev_ubuntu_connect`

All commands auto-include `docker-compose.local.yml` if it exists.
