# Devcontainer

An isolated development environment powered by Docker with Neovim, Node.js 24 LTS, and Python 3.12 pre-installed.

## What's Included

- **Ubuntu 22.04** base image
- **Neovim** (latest) with [custom configuration](https://github.com/KingNNT/neovim-configuration)
- **Node.js 24 LTS** via nvm
- **Python 3.12**
- **Build tools**: git, curl, wget, make, fzf

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2+)

## Quick Start

```bash
# 1. Clone this repo
git clone <repo-url> devcontainer
cd devcontainer

# 2. Build the image
make dev_build

# 3. Create docker-compose.local.yml to mount your project
cat > docker-compose.local.yml <<EOF
services:
  ubuntu:
    volumes:
      - /path/to/your/project:/workspace
EOF

# 4. Start the container
make dev_up

# 5. Connect and start coding
make dev_ubuntu_connect
cd /workspace
```

## How It Works

This repo builds a Docker image with all dev tools pre-installed. You mount your project directory into the container via `docker-compose.local.yml`, then connect and code inside it using Neovim.

```
Your machine                    Container
+-----------------------+       +---------------------------+
| ~/projects/my-app/ ---+-----> | /workspace/               |
+-----------------------+  vol  | neovim, node 24, python   |
                          mount | 3.12, git, fzf, ...       |
                                +---------------------------+
```

Files are shared — edits inside the container are reflected on your host and vice versa.

## Commands

| Command | Description |
|---------|-------------|
| `make dev_build` | Build the Docker image |
| `make dev_up` | Start the container |
| `make dev_down` | Stop the container |
| `make dev_ubuntu_connect` | Open a shell in the container |

## Local Overrides

The `docker-compose.local.yml` file is gitignored. Use it to add personal volume mounts (SSH keys, dotfiles, project dirs):

```yaml
services:
  ubuntu:
    volumes:
      - .:/workspace
      - ~/.ssh:/root/.ssh:ro
      - ~/.gitconfig:/root/.gitconfig:ro
```

## Project Structure

```
docker-compose.yml              # Base service definition
docker-compose.override.yml     # Dev defaults (auto-loaded)
docker-compose.local.yml        # Personal overrides (gitignored)
.docker/ubuntu/Dockerfile       # Container image definition
.docker/ubuntu/start-container  # Entrypoint script
```
