# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker-based isolated development environment — a single-service Ubuntu 22.04 container with Neovim, Node.js 24 LTS, and Python 3.12 pre-installed. Used as a portable dev workspace where projects are volume-mounted to `/app` in the container.

## Build & Run Commands

```bash
make build   # Build the Docker image
make run     # Start container (mounts current dir to /app)
make exec    # Open bash shell in running container
make stop    # Stop and remove container
```

## Architecture

```
.docker/ubuntu/
├── Dockerfile          # Full image build (Ubuntu 22.04, Neovim, Python 3.12, nvm, Node.js, Claude Code)
├── start-container     # Entrypoint: sources nvm, keeps container alive
└── claude/             # Claude Code user-level config (CLAUDE.md, settings.json)

Makefile                # All dev commands (docker build/run/exec/stop)
```

- Image name: `devcontainer`, container name: `devcontainer`
- Runs as non-root user `dev` (UID/GID 1000)
- Projects are volume-mounted to `/app` via `docker run -v .:/app`
- Neovim config is cloned from `github.com/KingNNT/neovim-configuration` (develop branch) during image build
- Node.js and nvm are installed at build time; `start-container` only sources nvm at runtime
- Claude Code CLI is installed at build time; alias `cc` runs it in permissive mode

## Shell Script Conventions

- Use `#!/usr/bin/env bash` (or `#!/bin/bash` for container scripts)
- Use `set -e` for fail-fast behavior
- 2-space indentation
- Quote all variables
