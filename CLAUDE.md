# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker-based isolated development environment — a single-service Ubuntu 22.04 container with Neovim, Node.js 24 LTS, and Python 3.12 pre-installed. Used as a portable dev workspace where projects are volume-mounted from the host.

## Build & Run Commands

```bash
make dev_build            # Build the Docker image
make dev_up               # Start container (detached)
make dev_down             # Stop container
make dev_ubuntu_connect   # Open bash shell in running container
```

## Docker Compose 3-Layer Override Pattern

The project uses Docker Compose V2's implicit override mechanism:

1. **`docker-compose.yml`** — Base service definition (service, build context, networks)
2. **`docker-compose.override.yml`** — Dev defaults, auto-loaded by Docker Compose
3. **`docker-compose.local.yml`** — Per-developer overrides (gitignored), auto-detected by Makefile via `wildcard`

The Makefile conditionally includes `docker-compose.local.yml` if it exists. This file is where developers add volume mounts for SSH keys, dotfiles, and project directories.

## Architecture

```
.docker/ubuntu/
├── Dockerfile          # Full image build (Ubuntu 22.04, Neovim, Python 3.12, nvm)
└── start-container     # Entrypoint: initializes nvm, installs Node.js 24 LTS

docker-compose.yml          # Base: single "ubuntu" service + bridge network
docker-compose.override.yml # Dev: restart policy
docker-compose.local.yml    # Local: volume mounts (gitignored)
Makefile                    # All dev commands
.env                        # APP_NAME used in container naming
```

- Container name uses `${APP_NAME}_ubuntu` from `.env`
- Neovim config is cloned from `github.com/KingNNT/neovim-configuration` (develop branch) during image build
- Node.js is installed at container startup (not build time) via nvm in `start-container`

## Shell Script Conventions

- Use `#!/usr/bin/env bash` (or `#!/bin/bash` for container scripts)
- Use `set -e` for fail-fast behavior
- 2-space indentation
- Quote all variables
