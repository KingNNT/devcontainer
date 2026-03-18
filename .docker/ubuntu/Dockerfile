ARG NODE_VERSION=24

FROM ubuntu:22.04

LABEL maintainer KingNNT

RUN apt update && apt install -y \
  locales \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt install -y \
  build-essential \
  git \
  curl \
  wget \
  make \
  fzf \
  software-properties-common

# Neovim (latest)
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
  && chmod u+x nvim.appimage \
  && ./nvim.appimage --appimage-extract \
  && ln -s /squashfs-root/AppRun /usr/bin/nvim \
  && rm nvim.appimage

# Node.js via nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Python 3.12 via deadsnakes PPA
RUN add-apt-repository -y ppa:deadsnakes/ppa \
  && apt update \
  && apt install -y python3.12 python3.12-venv python3.12-dev \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Neovim configuration
RUN git clone -b develop https://github.com/KingNNT/neovim-configuration ~/.config/nvim

COPY ./start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["/usr/local/bin/start-container"]
