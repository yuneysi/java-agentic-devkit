# DevKit Java Enterprise — Java 8/21 + Maven + Tomcat 9/11 + ActiveMQ + IBM MQ ready
# Base: Ubuntu 24.04

FROM ubuntu:24.04@sha256:fe81560990fae86dc4743202b2cb4d3df98d0bcf949173cecef15ce1127ef852

LABEL org.opencontainers.image.title="java-agentic-devkit" \
      org.opencontainers.image.description="Docker-based Java development kit for Java 8, Java 21, and Java 8 to Java 21 migrations." \
      org.opencontainers.image.authors="Yuneysi Gerat Gil" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/yuneysi/java-agentic-devkit"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ARG MAVEN_VERSION=3.9.16
ARG TOMCAT9_VERSION=9.0.123
ARG TOMCAT11_VERSION=11.0.27
# ActiveMQ Classic 6 (Spring 6, Java 17+); Java 8 clients still connect over OpenWire.
ARG ACTIVEMQ_VERSION=6.4.0

# Pinned tool versions (supply chain: no "latest" downloads).
ARG BUN_VERSION=1.4.4
ARG HADOLINT_VERSION=2.15.1
ARG SYFT_VERSION=1.55.0
ARG GRYPE_VERSION=0.121.0
ARG SONAR_SCANNER_VERSION=8.2.0.6438
ARG SEMGREP_VERSION=1.181.1
ARG CHECKOV_VERSION=3.3.30
ARG PLAYWRIGHT_MCP_VERSION=0.0.83
# Must match the Playwright build that @playwright/mcp@${PLAYWRIGHT_MCP_VERSION} depends on.
ARG PLAYWRIGHT_VERSION=1.64.0-alpha-1790635538000

ENV DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------------------
# Base OS tooling
# ---------------------------------------------------------------------
RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    wget \
    git \
    openssh-client \
    unzip \
    zip \
    jq \
    less \
    sudo \
    ripgrep \
    silversearcher-ag \
    fd-find \
    build-essential \
    procps \
    net-tools \
    iputils-ping \
    dnsutils \
    lsof \
    vim \
    nano \
    tree \
    htop \
    tmux \
    xmlstarlet \
    libxml2-utils \
    xsltproc \
    dos2unix \
    redis-server \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd

# ---------------------------------------------------------------------
# Non-root dev user
# ---------------------------------------------------------------------
RUN groupadd --gid ${USER_GID} ${USERNAME} 2>/dev/null \
    || groupmod -n "${USERNAME}" "$(getent group ${USER_GID} | cut -d: -f1)" \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash 2>/dev/null \
    || (usermod -l "${USERNAME}" "$(getent passwd ${USER_UID} | cut -d: -f1)" \
        && usermod -d "/home/${USERNAME}" -m "${USERNAME}" \
        && chsh -s /bin/bash "${USERNAME}") \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# ---------------------------------------------------------------------
# Java 8 + Java 21 (latest Temurin patch release on every build, SHA-256 verified)
# ---------------------------------------------------------------------
RUN mkdir -p /opt/java

RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
        amd64) ADOPTIUM_ARCH="x64" ;; \
        arm64) ADOPTIUM_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && ASSET="$(curl -fsSL "https://api.adoptium.net/v3/assets/latest/8/hotspot?architecture=${ADOPTIUM_ARCH}&image_type=jdk&os=linux&vendor=eclipse")" \
    && JDK_URL="$(printf '%s' "${ASSET}" | jq -r '.[0].binary.package.link')" \
    && JDK_SHA256="$(printf '%s' "${ASSET}" | jq -r '.[0].binary.package.checksum')" \
    && curl -fsSL -o /tmp/temurin8.tar.gz "${JDK_URL}" \
    && echo "${JDK_SHA256}  /tmp/temurin8.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/temurin8.tar.gz -C /opt/java \
    && mv /opt/java/jdk8* /opt/java/jdk8 \
    && rm /tmp/temurin8.tar.gz

RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
        amd64) ADOPTIUM_ARCH="x64" ;; \
        arm64) ADOPTIUM_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && ASSET="$(curl -fsSL "https://api.adoptium.net/v3/assets/latest/21/hotspot?architecture=${ADOPTIUM_ARCH}&image_type=jdk&os=linux&vendor=eclipse")" \
    && JDK_URL="$(printf '%s' "${ASSET}" | jq -r '.[0].binary.package.link')" \
    && JDK_SHA256="$(printf '%s' "${ASSET}" | jq -r '.[0].binary.package.checksum')" \
    && curl -fsSL -o /tmp/temurin21.tar.gz "${JDK_URL}" \
    && echo "${JDK_SHA256}  /tmp/temurin21.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/temurin21.tar.gz -C /opt/java \
    && mv /opt/java/jdk-21* /opt/java/jdk21 \
    && rm /tmp/temurin21.tar.gz

ENV JAVA8_HOME=/opt/java/jdk8
ENV JAVA21_HOME=/opt/java/jdk21
ENV DEFAULT_JAVA_TEMPLATE=java8
ENV JAVA_HOME=/opt/java/jdk8
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN update-alternatives --install /usr/bin/java java /opt/java/jdk8/bin/java 1080 \
    && update-alternatives --install /usr/bin/javac javac /opt/java/jdk8/bin/javac 1080 \
    && update-alternatives --install /usr/bin/jar jar /opt/java/jdk8/bin/jar 1080 \
    && update-alternatives --install /usr/bin/javadoc javadoc /opt/java/jdk8/bin/javadoc 1080 \
    && update-alternatives --install /usr/bin/java java /opt/java/jdk21/bin/java 2100 \
    && update-alternatives --install /usr/bin/javac javac /opt/java/jdk21/bin/javac 2100 \
    && update-alternatives --install /usr/bin/jar jar /opt/java/jdk21/bin/jar 2100 \
    && update-alternatives --install /usr/bin/javadoc javadoc /opt/java/jdk21/bin/javadoc 2100 \
    && update-alternatives --set java /opt/java/jdk8/bin/java \
    && update-alternatives --set javac /opt/java/jdk8/bin/javac \
    && update-alternatives --set jar /opt/java/jdk8/bin/jar \
    && update-alternatives --set javadoc /opt/java/jdk8/bin/javadoc

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'export JAVA_HOME=/opt/java/jdk8' \
    'export PATH="$JAVA_HOME/bin:${PATH}"' \
    'sudo update-alternatives --set java /opt/java/jdk8/bin/java >/dev/null' \
    'sudo update-alternatives --set javac /opt/java/jdk8/bin/javac >/dev/null' \
    'sudo update-alternatives --set jar /opt/java/jdk8/bin/jar >/dev/null' \
    'sudo update-alternatives --set javadoc /opt/java/jdk8/bin/javadoc >/dev/null' \
    'java -version' \
    > /usr/local/bin/use-java8

RUN chmod +x /usr/local/bin/use-java8

# Release version guard: checks Git and Nexus before a version is used (see the script header).
COPY --chmod=755 scripts/container/check-release-version.sh /usr/local/bin/check-release-version

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'export JAVA_HOME=/opt/java/jdk21' \
    'export PATH="$JAVA_HOME/bin:${PATH}"' \
    'sudo update-alternatives --set java /opt/java/jdk21/bin/java >/dev/null' \
    'sudo update-alternatives --set javac /opt/java/jdk21/bin/javac >/dev/null' \
    'sudo update-alternatives --set jar /opt/java/jdk21/bin/jar >/dev/null' \
    'sudo update-alternatives --set javadoc /opt/java/jdk21/bin/javadoc >/dev/null' \
    'java -version' \
    > /usr/local/bin/use-java21

RUN chmod +x /usr/local/bin/use-java21

# ---------------------------------------------------------------------
# Maven
# ---------------------------------------------------------------------
RUN curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    -o /tmp/maven.tar.gz \
    && echo "$(curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" | cut -d" " -f1)  /tmp/maven.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/maven.tar.gz -C /opt \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && ln -s /opt/maven/bin/mvn /usr/local/bin/mvn \
    && rm /tmp/maven.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"
ENV MAVEN_OPTS="-Dmaven.repo.local=/home/${USERNAME}/.m2/repository"

RUN mkdir -p /home/${USERNAME}/.m2/repository \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.m2

# ---------------------------------------------------------------------
# Tomcat 9 + Tomcat 11
# ---------------------------------------------------------------------
RUN mkdir -p /opt/tomcat

RUN curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT9_VERSION}/bin/apache-tomcat-${TOMCAT9_VERSION}.tar.gz" -o /tmp/tomcat9.tar.gz \
    && echo "$(curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT9_VERSION}/bin/apache-tomcat-${TOMCAT9_VERSION}.tar.gz.sha512" | cut -d" " -f1)  /tmp/tomcat9.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/tomcat9.tar.gz -C /opt/tomcat \
    && mv /opt/tomcat/apache-tomcat-${TOMCAT9_VERSION} /opt/tomcat/tomcat9 \
    && rm /tmp/tomcat9.tar.gz \
    && chmod +x /opt/tomcat/tomcat9/bin/*.sh

RUN curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-11/v${TOMCAT11_VERSION}/bin/apache-tomcat-${TOMCAT11_VERSION}.tar.gz" -o /tmp/tomcat11.tar.gz \
    && echo "$(curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-11/v${TOMCAT11_VERSION}/bin/apache-tomcat-${TOMCAT11_VERSION}.tar.gz.sha512" | cut -d" " -f1)  /tmp/tomcat11.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/tomcat11.tar.gz -C /opt/tomcat \
    && mv /opt/tomcat/apache-tomcat-${TOMCAT11_VERSION} /opt/tomcat/tomcat11 \
    && rm /tmp/tomcat11.tar.gz \
    && chmod +x /opt/tomcat/tomcat11/bin/*.sh

ENV TOMCAT9_HOME=/opt/tomcat/tomcat9
ENV TOMCAT11_HOME=/opt/tomcat/tomcat11
ENV CATALINA_HOME=/opt/tomcat/tomcat9

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'export JAVA_HOME=/opt/java/jdk8' \
    'export CATALINA_HOME=/opt/tomcat/tomcat9' \
    'export CATALINA_BASE=/opt/tomcat/tomcat9' \
    'exec "$CATALINA_HOME/bin/catalina.sh" run' \
    > /usr/local/bin/start-tomcat9

RUN chmod +x /usr/local/bin/start-tomcat9

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    '/opt/tomcat/tomcat9/bin/catalina.sh stop' \
    > /usr/local/bin/stop-tomcat9

RUN chmod +x /usr/local/bin/stop-tomcat9

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'export JAVA_HOME=/opt/java/jdk21' \
    'export CATALINA_HOME=/opt/tomcat/tomcat11' \
    'export CATALINA_BASE=/opt/tomcat/tomcat11' \
    'exec "$CATALINA_HOME/bin/catalina.sh" run' \
    > /usr/local/bin/start-tomcat11

RUN chmod +x /usr/local/bin/start-tomcat11

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    '/opt/tomcat/tomcat11/bin/catalina.sh stop' \
    > /usr/local/bin/stop-tomcat11

RUN chmod +x /usr/local/bin/stop-tomcat11

# ---------------------------------------------------------------------
# ActiveMQ Classic
# ---------------------------------------------------------------------
RUN mkdir -p /opt/activemq \
    && curl -fsSL "https://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz" -o /tmp/activemq.tar.gz \
    && echo "$(curl -fsSL "https://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz.sha512" | cut -d" " -f1)  /tmp/activemq.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/activemq.tar.gz -C /opt/activemq --strip-components=1 \
    && rm /tmp/activemq.tar.gz \
    && chmod +x /opt/activemq/bin/activemq

ENV ACTIVEMQ_HOME=/opt/activemq
ENV PATH="${ACTIVEMQ_HOME}/bin:${PATH}"

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'export JAVA_HOME=/opt/java/jdk21' \
    'exec /opt/activemq/bin/activemq console' \
    > /usr/local/bin/start-activemq

RUN chmod +x /usr/local/bin/start-activemq

# ---------------------------------------------------------------------
# Redis
# ---------------------------------------------------------------------
RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'exec redis-server --save "" --appendonly no --bind 0.0.0.0' \
    > /usr/local/bin/start-redis

RUN chmod +x /usr/local/bin/start-redis

# ---------------------------------------------------------------------
# IBM MQ support
# ---------------------------------------------------------------------
RUN mkdir -p /opt/mqm \
    && chown -R ${USERNAME}:${USERNAME} /opt/mqm

ENV MQ_INSTALLATION_PATH=/opt/mqm
ENV IBM_MQ_HOME=/opt/mqm
ENV LD_LIBRARY_PATH="/opt/mqm/lib64:/opt/mqm/lib"

# ---------------------------------------------------------------------
# Node.js, npm, Bun, JS tooling
# ---------------------------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm config set fund false \
    && npm config set update-notifier false

RUN npm install -g \
    typescript@6.0.3 \
    typescript-language-server@6.0.2 \
    @biomejs/biome@2.6.3 \
    opencode-codebase-index@0.38.2 \
    @playwright/mcp@${PLAYWRIGHT_MCP_VERSION}

# Browser for the Playwright MCP server.
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright
RUN npx -y playwright@${PLAYWRIGHT_VERSION} install --with-deps chromium \
    && chmod -R a+rX /opt/ms-playwright \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}" \
    && mv /root/.bun/bin/bun /usr/local/bin/bun \
    && ln -sf /usr/local/bin/bun /usr/local/bin/bunx \
    && rm -rf /root/.bun

# ---------------------------------------------------------------------
# Quality/security tools
# ---------------------------------------------------------------------
RUN python3 -m pip install --no-cache-dir --break-system-packages \
    "semgrep==${SEMGREP_VERSION}" \
    "checkov==${CHECKOV_VERSION}"

RUN ARCH="$(uname -m)" \
    && case "$ARCH" in x86_64) HADOLINT_ARCH="x86_64" ;; aarch64) HADOLINT_ARCH="arm64" ;; *) exit 1 ;; esac \
    && curl -sSfL "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-${HADOLINT_ARCH}" \
       -o /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint

RUN curl -sSfL "https://raw.githubusercontent.com/anchore/syft/v${SYFT_VERSION}/install.sh" | sh -s -- -b /usr/local/bin "v${SYFT_VERSION}" \
    && curl -sSfL "https://raw.githubusercontent.com/anchore/grype/v${GRYPE_VERSION}/install.sh" | sh -s -- -b /usr/local/bin "v${GRYPE_VERSION}"

RUN ARCH="$(uname -m)" \
    && case "$ARCH" in \
        x86_64) SONAR_ARCH="linux-x64" ;; \
        aarch64) SONAR_ARCH="linux-aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && echo "Installing SonarScanner ${SONAR_SCANNER_VERSION} for ${SONAR_ARCH}" \
    && curl -fsSL "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-${SONAR_ARCH}.zip" \
       -o /tmp/sonar-scanner.zip \
    && unzip -q /tmp/sonar-scanner.zip -d /opt \
    && mv /opt/sonar-scanner-*-${SONAR_ARCH} /opt/sonar-scanner \
    && ln -sf /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner \
    && rm /tmp/sonar-scanner.zip

# ---------------------------------------------------------------------
# Java LSP - Eclipse JDT Language Server (Optional)
# Note: JDTLS download is optional due to URL availability issues
# Can be installed on demand via: npm install -g eclipse-jdtls
# or manually: https://github.com/eclipse/eclipse.jdt.ls/releases
# ---------------------------------------------------------------------
RUN mkdir -p /opt/jdtls || true

RUN printf '%s\n' \
                '#!/usr/bin/env bash' \
                'exec /opt/java/jdk21/bin/java \' \
                '  -Declipse.application=org.eclipse.jdt.ls.core.id1 \' \
                '  -Dosgi.bundles.defaultStartLevel=4 \' \
                '  -Declipse.product=org.eclipse.jdt.ls.core.product \' \
                '  -Dlog.protocol=true \' \
                '  -Dlog.level=ALL \' \
                '  -Xmx2G \' \
                '  --add-modules=ALL-SYSTEM \' \
                '  --add-opens java.base/java.util=ALL-UNNAMED \' \
                '  --add-opens java.base/java.lang=ALL-UNNAMED \' \
                '  -jar /opt/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \' \
                '  -configuration /opt/jdtls/config_linux \' \
                '  -data "${JDTLS_WORKSPACE:-/var/tmp/jdtls-workspace}"' \
                > /usr/local/bin/jdtls

RUN chmod +x /usr/local/bin/jdtls \
    && mkdir -p /var/tmp/jdtls-workspace \
    && chown -R ${USERNAME}:${USERNAME} /var/tmp/jdtls-workspace

# ---------------------------------------------------------------------
# OpenCode + oh-my-openagent
# ---------------------------------------------------------------------
# Keep V1: OmO 5.1.65 does not activate its agents/tools/hooks on OpenCode 2.
RUN npm install -g opencode-ai@1.19.5 oh-my-openagent@5.1.65

# OpenAI Codex CLI. Pinned; rebuild the image to update.
ARG CODEX_VERSION=0.164.0
RUN npm install -g @openai/codex@${CODEX_VERSION} \
    && codex --version

# OpenSpec: spec-driven changes with versioned specs and an archive of applied changes.
# The entrypoint runs `openspec init --tools opencode,claude,codex` once per target project
# when template bootstrap is enabled.
# Versions are pinned in the image and global npm packages are root-owned, so a self-upgrade
# prompt can only fail with EACCES. Rebuild the image to update OpenSpec.
ENV OPENSPEC_NO_UPDATE_CHECK=1
RUN npm install -g @fission-ai/openspec@1.15.0 \
    && openspec --version

RUN mkdir -p /workspace \
    && chown ${USERNAME}:${USERNAME} /workspace

RUN mkdir -p \
    /home/${USERNAME}/.config/opencode \
    /home/${USERNAME}/.local/share/opencode \
    /home/${USERNAME}/.codex \
    /home/${USERNAME}/.agents \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.codex /home/${USERNAME}/.agents

# ---------------------------------------------------------------------
# Git performance + shell helpers
# ---------------------------------------------------------------------
USER ${USERNAME}

# ---------------------------------------------------------------------
# Claude Code (native installer, per-user under ~/.local/bin)
# ---------------------------------------------------------------------
# Channel or exact version accepted by the installer: stable, latest, or X.Y.Z.
ARG CLAUDE_CODE_VERSION=stable
# Keep the image reproducible; rebuild the image to update Claude Code.
ENV DISABLE_AUTOUPDATER=1
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

RUN curl -fsSL https://claude.ai/install.sh | bash -s -- "${CLAUDE_CODE_VERSION}" \
    && claude --version

RUN git config --global core.untrackedcache true \
    && git config --global core.fsmonitor true \
    && git config --global feature.manyFiles true \
    && git config --global pull.rebase false

RUN printf '%s\n' \
    '' \
    '# Java helpers' \
    "alias java8='source /usr/local/bin/use-java8'" \
    "alias java21='source /usr/local/bin/use-java21'" \
    '' \
    '# Tomcat helpers' \
    "alias t9='start-tomcat9'" \
    "alias t11='start-tomcat11'" \
    '' \
    '# Maven helpers' \
    "alias mvn8='JAVA_HOME=/opt/java/jdk8 mvn'" \
    "alias mvn21='JAVA_HOME=/opt/java/jdk21 mvn'" \
    '' \
    '# Runtime paths' \
    'export JAVA8_HOME=/opt/java/jdk8' \
    'export JAVA21_HOME=/opt/java/jdk21' \
    'case "${DEVKIT_JAVA_TEMPLATE:-${DEFAULT_JAVA_TEMPLATE:-java8}}" in' \
    '    java21)' \
    '        . /usr/local/bin/use-java21 >/dev/null 2>&1 || true' \
    '        ;;' \
    '    java8|java21-migration|*)' \
    '        . /usr/local/bin/use-java8 >/dev/null 2>&1 || true' \
    '        ;;' \
    'esac' \
    'export MAVEN_HOME=/opt/maven' \
    'export MAVEN_OPTS="-Dmaven.repo.local=/home/vscode/.m2/repository"' \
    'export TOMCAT9_HOME=/opt/tomcat/tomcat9' \
    'export TOMCAT11_HOME=/opt/tomcat/tomcat11' \
    'export ACTIVEMQ_HOME=/opt/activemq' \
    'export MQ_INSTALLATION_PATH=/opt/mqm' \
    'export IBM_MQ_HOME=/opt/mqm' \
    'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}:/opt/mqm/lib64:/opt/mqm/lib"' \
    >> /home/${USERNAME}/.bashrc

WORKDIR /workspace

RUN java -version \
    && javac -version \
    && /opt/java/jdk21/bin/java -version \
    && /opt/java/jdk21/bin/javac -version \
    && mvn -version \
    && /opt/tomcat/tomcat9/bin/version.sh \
    && /opt/tomcat/tomcat11/bin/version.sh \
    && /opt/activemq/bin/activemq --version || true \
    && git --version \
    && node --version \
    && npm --version \
    && bun --version \
    && opencode --version 2>/dev/null || echo "OpenCode installed"

# ---------------------------------------------------------------------
# External OpenCode config
# ---------------------------------------------------------------------
COPY --chown=${USERNAME}:${USERNAME} opencode/opencode.json /home/${USERNAME}/.config/opencode/opencode.json
COPY --chown=${USERNAME}:${USERNAME} opencode/omo.jsonc /home/${USERNAME}/.omo/omo.jsonc
COPY --chown=${USERNAME}:${USERNAME} opencode/tui.json /home/${USERNAME}/.config/opencode/tui.json
# Global agent instructions (work mode and OpenSpec), shared by Claude Code, OpenCode, and Codex.
COPY --chown=${USERNAME}:${USERNAME} claude/CLAUDE.md /home/${USERNAME}/.claude/CLAUDE.md
COPY --chown=${USERNAME}:${USERNAME} claude/CLAUDE.md /home/${USERNAME}/.config/opencode/AGENTS.md
COPY --chown=${USERNAME}:${USERNAME} claude/CLAUDE.md /home/${USERNAME}/.codex/AGENTS.md
# Codex: approval on request; the container is the sandbox boundary (see the file header).
COPY --chown=${USERNAME}:${USERNAME} codex/config.toml /home/${USERNAME}/.codex/config.toml
# Claude Code starts in auto mode. Secret-file read denies ship in each project's
# .claude/settings.json from the templates; the devkit policy is to keep them.
COPY --chown=${USERNAME}:${USERNAME} claude/settings.json /home/${USERNAME}/.claude/settings.json

# ---------------------------------------------------------------------
# Skills for OpenCode and Claude Code
# ---------------------------------------------------------------------
# The installer verifies community skill checksums and installs one flat
# directory per skill, which both runtimes discover.
ARG SKILLS_SRC=/opt/java-agentic-devkit/skills-src
COPY scripts/install-skills.py ${SKILLS_SRC}/scripts/install-skills.py
COPY opencode/community-skills.lock.json ${SKILLS_SRC}/opencode/community-skills.lock.json
COPY opencode/skills/ ${SKILLS_SRC}/opencode/skills/
COPY templates/java21-migration/skills/ ${SKILLS_SRC}/templates/java21-migration/skills/

RUN python3 -I ${SKILLS_SRC}/scripts/install-skills.py --agent opencode \
    && python3 -I ${SKILLS_SRC}/scripts/install-skills.py --agent claude \
    && python3 -I ${SKILLS_SRC}/scripts/install-skills.py --agent codex

USER root

COPY templates/java8/ /opt/java-agentic-devkit/templates/java8/
COPY templates/java21/ /opt/java-agentic-devkit/templates/java21/
COPY templates/java21-migration/ /opt/java-agentic-devkit/templates/java21-migration/

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'set -euo pipefail' \
    '' \
    'PROJECT_DIR="${DEVKIT_PROJECT_DIR:-}"' \
    'JAVA_TEMPLATE="${DEVKIT_JAVA_TEMPLATE:-${DEFAULT_JAVA_TEMPLATE:-java8}}"' \
    'BOOTSTRAP_TEMPLATES="${DEVKIT_BOOTSTRAP_TEMPLATES:-true}"' \
    '' \
    'if [[ -z "${PROJECT_DIR}" ]]; then' \
    '    PROJECT_DIR=/workspace' \
    'fi' \
    '' \
    'case "${JAVA_TEMPLATE}" in' \
    '    java8)' \
    '        . /usr/local/bin/use-java8 >/dev/null 2>&1 || true' \
    '        ;;' \
    '    java21)' \
    '        . /usr/local/bin/use-java21 >/dev/null 2>&1 || true' \
    '        ;;' \
    '    java21-migration)' \
    '        . /usr/local/bin/use-java8 >/dev/null 2>&1 || true' \
    '        ;;' \
    '    *)' \
    '        echo "Unsupported DEVKIT_JAVA_TEMPLATE: ${JAVA_TEMPLATE}" >&2' \
    '        exit 1' \
    '        ;;' \
    'esac' \
    '' \
    'TEMPLATE_DIR="/opt/java-agentic-devkit/templates/${JAVA_TEMPLATE}"' \
    'if [[ "${BOOTSTRAP_TEMPLATES}" != "false" && -d "${PROJECT_DIR}" && -d "${TEMPLATE_DIR}" ]]; then' \
    '    while IFS= read -r -d "" TEMPLATE_FILE; do' \
    '        RELATIVE_PATH="${TEMPLATE_FILE#${TEMPLATE_DIR}/}"' \
    '        if [[ "${JAVA_TEMPLATE}" == "java21-migration" && "${RELATIVE_PATH}" == "README.md" ]]; then' \
    '            RELATIVE_PATH="docs/java21-migration-guide.md"' \
    '        fi' \
    '        if [[ "${JAVA_TEMPLATE}" == "java21-migration" && "${RELATIVE_PATH}" == "docs/migration-progress-checklist-template.md" ]]; then' \
    '            RELATIVE_PATH="docs/migration-progress-checklist.md"' \
    '        fi' \
    '        TARGET_FILE="${PROJECT_DIR}/${RELATIVE_PATH}"' \
    '        mkdir -p "$(dirname "${TARGET_FILE}")"' \
    '        if [[ ! -e "${TARGET_FILE}" ]]; then' \
    '            cp "${TEMPLATE_FILE}" "${TARGET_FILE}"' \
    '            echo "Created ${RELATIVE_PATH} from ${JAVA_TEMPLATE} template"' \
    '        fi' \
    '    done < <(find "${TEMPLATE_DIR}" -type f ! -path "${TEMPLATE_DIR}/scripts/*" -print0)' \
    'fi' \
    '' \
    '# Initialize OpenSpec once: generates the /opsx commands and keeps openspec/config.yaml.' \
    'if [[ "${BOOTSTRAP_TEMPLATES}" != "false" && -f "${PROJECT_DIR}/openspec/config.yaml" && ! -d "${PROJECT_DIR}/.claude/commands/opsx" && ! -e "${PROJECT_DIR}/.opencode/commands/opsx-propose.md" ]]; then' \
    '    if (cd "${PROJECT_DIR}" && openspec init --tools opencode,claude,codex < /dev/null > /dev/null 2>&1); then' \
    '        echo "Initialized OpenSpec (openspec/, .claude/, .opencode/, .agents/)"' \
    '    else' \
    '        echo "OpenSpec init failed; run: openspec init --tools opencode,claude,codex" >&2' \
    '    fi' \
    'fi' \
    '' \
    'exec "$@"' \
    > /usr/local/bin/devkit-entrypoint

RUN chmod +x /usr/local/bin/devkit-entrypoint

USER ${USERNAME}

EXPOSE 8080 8009 5005 61616 6379 8161

ENTRYPOINT ["devkit-entrypoint"]
CMD ["bash"]
