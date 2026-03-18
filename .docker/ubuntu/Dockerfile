FROM ubuntu:22.04

LABEL maintainer="KingNNT"

ARG NODE_VERSION=24
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

# System packages: locales, build tools, Python 3.12
RUN apt-get update && apt-get install -y --no-install-recommends \
  locales \
  build-essential \
  git \
  curl \
  wget \
  make \
  fzf \
  gpg \
  gpg-agent \
  software-properties-common \
  unzip \
  libreadline-dev \
  sudo \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install -y --no-install-recommends python3.12 python3.12-venv python3.12-dev \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.utf8
ENV TERM=xterm-256color

# Create non-root user
RUN groupadd --gid "$USER_GID" "$USERNAME" \
  && useradd --uid "$USER_UID" --gid "$USER_GID" -m -s /bin/bash "$USERNAME" \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/"$USERNAME"

# Neovim (latest release tarball, arch-aware)
ARG TARGETARCH
RUN NVIM_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "nvim-linux-arm64" || echo "nvim-linux-x86_64") \
  && curl -fL "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ARCH}.tar.gz" \
  | tar -xz -C /opt \
  && ln -s "/opt/${NVIM_ARCH}/bin/nvim" /usr/bin/nvim

# Switch to non-root user
USER $USERNAME
ENV HOME=/home/$USERNAME

# Node.js via nvm (installed at build time)
ENV NVM_DIR=$HOME/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
  && . "$NVM_DIR/nvm.sh" \
  && nvm install "$NODE_VERSION" \
  && nvm alias default "$NODE_VERSION"

# Claude Code (CLI)
ENV PATH=$HOME/.local/bin:$PATH
RUN curl -fsSL https://claude.ai/install.sh | bash

# Claude Code: user-level configuration
COPY --chown=$USERNAME:$USERNAME claude/ $HOME/.claude/

# Shell alias: cc = claude code in YOLO mode
RUN echo 'alias cc="claude --dangerously-skip-permissions"' >> "$HOME/.bashrc"

WORKDIR /app

# Neovim configuration
RUN git clone -b develop https://github.com/KingNNT/neovim-configuration "$HOME/.config/nvim"

# Enable OSC 52 clipboard for container environments
RUN mkdir -p "$HOME/.config/nvim/after/plugin" \
  && echo 'vim.g.clipboard = "osc52"' > "$HOME/.config/nvim/after/plugin/clipboard.lua"

COPY --chmod=+x ./start-container /usr/local/bin/start-container

ENTRYPOINT ["/usr/local/bin/start-container"]
