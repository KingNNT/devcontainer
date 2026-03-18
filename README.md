# Devcontainer

An isolated development environment powered by Docker with Neovim, Node.js 24 LTS, and Python 3.12 pre-installed.

## What's Included

- **Ubuntu 22.04** base image
- **Neovim** (latest) with [custom configuration](https://github.com/KingNNT/neovim-configuration)
- **Node.js 24 LTS** via nvm
- **Python 3.12**
- **Claude Code** CLI (alias `cc` for permissive mode)
- **Build tools**: git, curl, wget, make, fzf
- Non-root user `dev` with sudo access

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)

## Quick Start

```bash
# 1. Clone this repo
git clone <repo-url> devcontainer
cd devcontainer

# 2. Build the image
make build

# 3. Run the container (mounts current directory to /app)
make run

# 4. Connect and start coding
make exec
cd /app
```

## Usage

The image is meant to be run from any project directory. Mount your project to `/app`:

```bash
docker run -d --name devcontainer -v /path/to/project:/app devcontainer
docker exec -it devcontainer bash
```

Files are shared — edits inside the container are reflected on your host and vice versa.

```
Your machine                    Container
+-----------------------+       +---------------------------+
| ~/projects/my-app/ ---+-----> | /app/                     |
+-----------------------+  vol  | neovim, node 24, python   |
                          mount | 3.12, git, fzf, ...       |
                                +---------------------------+
```

## Commands

| Command | Description |
|---------|-------------|
| `make build` | Build the Docker image |
| `make run` | Start the container (mounts `.` to `/app`) |
| `make run-workspace` | Start the container (mounts `~/Documents/workspaces` to `/app`) |
| `make exec` | Open a shell in the container |
| `make stop` | Stop and remove the container |

## Project Structure

```
.docker/ubuntu/
├── Dockerfile                  # Container image definition
├── start-container             # Entrypoint script
└── claude/                     # Claude Code user-level config
Makefile                        # All dev commands
```
