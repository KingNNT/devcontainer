# Docker Override Pattern Refactor — Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the Docker environment from a single environment-named compose file to the standard 3-layer override pattern with per-developer local overrides.

**Architecture:** Split `docker-compose.development.yml` into `docker-compose.yml` (base) + `docker-compose.override.yml` (dev defaults), auto-loaded by Docker Compose. A gitignored `docker-compose.local.yml` supports per-developer volume mounts, auto-detected by the Makefile.

**Tech Stack:** Docker Compose, Make

**Spec:** `docs/superpowers/specs/2026-03-18-docker-override-pattern-design.md`

---

### Task 1: Create the 3-layer Docker Compose files

**Files:**
- Create: `docker-compose.yml`
- Create: `docker-compose.override.yml`
- Remove: `docker-compose.development.yml`

- [ ] **Step 1: Create `docker-compose.yml` (base layer)**

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

Note: `version: "3.9"` is intentionally omitted — obsolete since Docker Compose V2.

- [ ] **Step 2: Create `docker-compose.override.yml` (dev override layer)**

```yaml
services:
  ubuntu:
    restart: unless-stopped
```

- [ ] **Step 3: Commit**

```bash
git add docker-compose.yml docker-compose.override.yml
git rm docker-compose.development.yml
git commit -m "refactor: replace docker-compose.development.yml with 3-layer override pattern"
```

> **Note:** `docker compose config` will fail until Task 2 is complete (build context `.docker/ubuntu/` does not exist yet). Do not validate between tasks.

---

### Task 2: Move and fix Docker build files

**Files:**
- Move: `.docker/development/ubuntu/Dockerfile` → `.docker/ubuntu/Dockerfile`
- Move: `.docker/development/ubuntu/start-container` → `.docker/ubuntu/start-container`
- Remove: `.docker/development/ubuntu/` and `.docker/development/` (empty dirs)

- [ ] **Step 1: Move files using `git mv`**

```bash
mkdir -p .docker/ubuntu
git mv .docker/development/ubuntu/Dockerfile .docker/ubuntu/Dockerfile
git mv .docker/development/ubuntu/start-container .docker/ubuntu/start-container
```

- [ ] **Step 2: Remove empty directories**

```bash
rmdir .docker/development/ubuntu .docker/development
```

- [ ] **Step 3: Fix shebang bug in `start-container`**

In `.docker/ubuntu/start-container`, change line 1 from `#!bin/bash` to `#!/bin/bash`.

- [ ] **Step 4: Verify Dockerfile is unchanged**

Read `.docker/ubuntu/Dockerfile` and confirm it matches the original content exactly.

- [ ] **Step 5: Commit**

```bash
git add -A .docker/
git commit -m "refactor: flatten .docker/development/ubuntu to .docker/ubuntu

Also fixes shebang in start-container: #!bin/bash -> #!/bin/bash"
```

---

### Task 3: Update Makefile and create .gitignore

**Files:**
- Modify: `Makefile`
- Create: `.gitignore`

- [ ] **Step 1: Replace Makefile contents**

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

Note: The old Makefile had a `-` prefix (Make's "ignore errors") on the connect command — this is intentionally removed as a bug fix.

- [ ] **Step 2: Create `.gitignore`**

```
docker-compose.local.yml
```

- [ ] **Step 3: Commit**

```bash
git add Makefile .gitignore
git commit -m "refactor: update Makefile with compose override targets and add .gitignore"
```

---

### Task 4: Validate the setup

- [ ] **Step 1: Verify `docker compose config` works**

```bash
docker compose config
```

Expected: merged YAML output showing the ubuntu service with `restart: unless-stopped`, build context `./.docker/ubuntu`, and no errors.

- [ ] **Step 2: Verify local override merges correctly (optional, if file exists)**

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.local.yml config
```

Expected: same as above plus `volumes` section.

- [ ] **Step 3: Verify Make targets list correctly**

```bash
make -n dev_up
```

Expected: prints the `docker compose ... up -d` command without executing.
