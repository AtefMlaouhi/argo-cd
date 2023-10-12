# syntax=docker/dockerfile:1.4
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.224.2/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT="hirsute"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends build-essential libz-dev zlib1g-dev \
    && apt -y install direnv pass bash-completion \
    && rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/bash' > /usr/local/bin/xdg-open \
    && echo 'sleep 60' >> /usr/local/bin/xdg-open \
    && chmod +x /usr/local/bin/xdg-open

ARG USERNAME=vscode
ARG GITLEAKS_VERSION=8.13.0
ARG YQ_VERSION=4.27.3

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && mkdir -p /home/$USERNAME/.local/share/direnv \
    && chown -R $USERNAME /home/$USERNAME/.local/share/direnv \
    && curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
    && curl -sSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 \
    && curl -sL https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz | tar xvz -C /usr/local/bin \
    && chmod +x /usr/local/bin/argocd /usr/local/bin/yq /usr/local/bin/gitleaks \
    && echo $SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo 'eval "$(direnv hook bash)"' >> "/home/$USERNAME/.bashrc" \
    && echo $SNIPPET >> "/home/$USERNAME/.zshrc" \
    && echo 'eval "$(direnv hook zsh)"' >> "/home/$USERNAME/.zshrc" \
    && echo 'alias tf=terraform' >> "/home/$USERNAME/.zshrc"
