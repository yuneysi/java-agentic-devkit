# DevKit Java Enterprise — Java 8/21 + Maven + Tomcat 9/11 + ActiveMQ + IBM MQ ready
# Base: Ubuntu 24.04

FROM ubuntu:24.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ARG MAVEN_VERSION=3.9.11
ARG TOMCAT9_VERSION=9.0.105
ARG TOMCAT11_VERSION=11.0.7
ARG ACTIVEMQ_VERSION=5.18.7

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# ---------------------------------------------------------------------
# Base OS tooling
# ---------------------------------------------------------------------
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --no-install-recommends \
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
    fzf \
    tmux \
    xmlstarlet \
    libxml2-utils \
    xsltproc \
    dos2unix \
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
# Java 8 + Java 21
# ---------------------------------------------------------------------
RUN mkdir -p /opt/java

RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
        amd64) ADOPTIUM_ARCH="x64" ;; \
        arm64) ADOPTIUM_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && curl -L -o /tmp/temurin8.tar.gz \
       "https://api.adoptium.net/v3/binary/latest/8/ga/linux/${ADOPTIUM_ARCH}/jdk/hotspot/normal/eclipse" \
    && tar -xzf /tmp/temurin8.tar.gz -C /opt/java \
    && mv /opt/java/jdk8* /opt/java/jdk8 \
    && rm /tmp/temurin8.tar.gz

RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
        amd64) ADOPTIUM_ARCH="x64" ;; \
        arm64) ADOPTIUM_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && curl -L -o /tmp/temurin21.tar.gz \
       "https://api.adoptium.net/v3/binary/latest/21/ga/linux/${ADOPTIUM_ARCH}/jdk/hotspot/normal/eclipse" \
    && tar -xzf /tmp/temurin21.tar.gz -C /opt/java \
    && mv /opt/java/jdk-21* /opt/java/jdk21 \
    && rm /tmp/temurin21.tar.gz

ENV JAVA8_HOME=/opt/java/jdk8
ENV JAVA21_HOME=/opt/java/jdk21
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

RUN cat > /usr/local/bin/use-java8 <<'EOF'
#!/usr/bin/env bash
export JAVA_HOME=/opt/java/jdk8
export PATH="$JAVA_HOME/bin:${PATH}"
sudo update-alternatives --set java /opt/java/jdk8/bin/java >/dev/null
sudo update-alternatives --set javac /opt/java/jdk8/bin/javac >/dev/null
sudo update-alternatives --set jar /opt/java/jdk8/bin/jar >/dev/null
sudo update-alternatives --set javadoc /opt/java/jdk8/bin/javadoc >/dev/null
java -version
EOF

RUN chmod +x /usr/local/bin/use-java8

RUN cat > /usr/local/bin/use-java21 <<'EOF'
#!/usr/bin/env bash
export JAVA_HOME=/opt/java/jdk21
export PATH="$JAVA_HOME/bin:${PATH}"
sudo update-alternatives --set java /opt/java/jdk21/bin/java >/dev/null
sudo update-alternatives --set javac /opt/java/jdk21/bin/javac >/dev/null
sudo update-alternatives --set jar /opt/java/jdk21/bin/jar >/dev/null
sudo update-alternatives --set javadoc /opt/java/jdk21/bin/javadoc >/dev/null
java -version
EOF

RUN chmod +x /usr/local/bin/use-java21

# ---------------------------------------------------------------------
# Maven
# ---------------------------------------------------------------------
RUN curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    -o /tmp/maven.tar.gz \
    && tar -xzf /tmp/maven.tar.gz -C /opt \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && ln -s /opt/maven/bin/mvn /usr/local/bin/mvn \
    && rm /tmp/maven.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"
ENV MAVEN_OPTS="-Dmaven.repo.local=/var/tmp/m2/repository"

RUN mkdir -p /var/tmp/m2/repository \
    && chown -R ${USERNAME}:${USERNAME} /var/tmp/m2

# ---------------------------------------------------------------------
# Tomcat 9 + Tomcat 11
# ---------------------------------------------------------------------
RUN mkdir -p /opt/tomcat

RUN curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT9_VERSION}/bin/apache-tomcat-${TOMCAT9_VERSION}.tar.gz" \
    -o /tmp/tomcat9.tar.gz \
    && tar -xzf /tmp/tomcat9.tar.gz -C /opt/tomcat \
    && mv /opt/tomcat/apache-tomcat-${TOMCAT9_VERSION} /opt/tomcat/tomcat9 \
    && rm /tmp/tomcat9.tar.gz \
    && chmod +x /opt/tomcat/tomcat9/bin/*.sh

RUN curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-11/v${TOMCAT11_VERSION}/bin/apache-tomcat-${TOMCAT11_VERSION}.tar.gz" \
    -o /tmp/tomcat11.tar.gz \
    && tar -xzf /tmp/tomcat11.tar.gz -C /opt/tomcat \
    && mv /opt/tomcat/apache-tomcat-${TOMCAT11_VERSION} /opt/tomcat/tomcat11 \
    && rm /tmp/tomcat11.tar.gz \
    && chmod +x /opt/tomcat/tomcat11/bin/*.sh

ENV TOMCAT9_HOME=/opt/tomcat/tomcat9
ENV TOMCAT11_HOME=/opt/tomcat/tomcat11
ENV CATALINA_HOME=/opt/tomcat/tomcat9

RUN cat > /usr/local/bin/start-tomcat9 <<'EOF'
#!/usr/bin/env bash
export JAVA_HOME=/opt/java/jdk8
export CATALINA_HOME=/opt/tomcat/tomcat9
export CATALINA_BASE=/opt/tomcat/tomcat9
exec "$CATALINA_HOME/bin/catalina.sh" run
EOF

RUN chmod +x /usr/local/bin/start-tomcat9

RUN cat > /usr/local/bin/stop-tomcat9 <<'EOF'
#!/usr/bin/env bash
/opt/tomcat/tomcat9/bin/catalina.sh stop
EOF

RUN chmod +x /usr/local/bin/stop-tomcat9

RUN cat > /usr/local/bin/start-tomcat11 <<'EOF'
#!/usr/bin/env bash
export JAVA_HOME=/opt/java/jdk21
export CATALINA_HOME=/opt/tomcat/tomcat11
export CATALINA_BASE=/opt/tomcat/tomcat11
exec "$CATALINA_HOME/bin/catalina.sh" run
EOF

RUN chmod +x /usr/local/bin/start-tomcat11

RUN cat > /usr/local/bin/stop-tomcat11 <<'EOF'
#!/usr/bin/env bash
/opt/tomcat/tomcat11/bin/catalina.sh stop
EOF

RUN chmod +x /usr/local/bin/stop-tomcat11

# ---------------------------------------------------------------------
# ActiveMQ Classic
# ---------------------------------------------------------------------
RUN mkdir -p /opt/activemq \
    && curl -fsSL "https://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz" \
       -o /tmp/activemq.tar.gz \
    && tar -xzf /tmp/activemq.tar.gz -C /opt/activemq --strip-components=1 \
    && rm /tmp/activemq.tar.gz \
    && chmod +x /opt/activemq/bin/activemq

ENV ACTIVEMQ_HOME=/opt/activemq
ENV PATH="${ACTIVEMQ_HOME}/bin:${PATH}"

RUN cat > /usr/local/bin/start-activemq <<'EOF'
#!/usr/bin/env bash
export JAVA_HOME=/opt/java/jdk8
exec /opt/activemq/bin/activemq console
EOF

RUN chmod +x /usr/local/bin/start-activemq

# ---------------------------------------------------------------------
# IBM MQ support
# ---------------------------------------------------------------------
RUN mkdir -p /opt/mqm \
    && chown -R ${USERNAME}:${USERNAME} /opt/mqm

ENV MQ_INSTALLATION_PATH=/opt/mqm
ENV IBM_MQ_HOME=/opt/mqm
ENV LD_LIBRARY_PATH="/opt/mqm/lib64:/opt/mqm/lib:${LD_LIBRARY_PATH}"

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
    typescript \
    typescript-language-server \
    @biomejs/biome \
    opencode-codebase-index \
    @modelcontextprotocol/server-github \
    @modelcontextprotocol/server-sequential-thinking \
    @playwright/mcp@0.0.69

RUN curl -fsSL https://bun.sh/install | bash \
    && mv /root/.bun/bin/bun /usr/local/bin/bun \
    && ln -sf /usr/local/bin/bun /usr/local/bin/bunx \
    && rm -rf /root/.bun

# ---------------------------------------------------------------------
# Quality/security tools
# gitleaks intentionally not installed/enforced because this project
# currently keeps secrets in Git.
# ---------------------------------------------------------------------
RUN python3 -m pip install --no-cache-dir --break-system-packages \
    semgrep \
    checkov

RUN ARCH="$(uname -m)" \
    && case "$ARCH" in x86_64) HADOLINT_ARCH="x86_64" ;; aarch64) HADOLINT_ARCH="arm64" ;; *) exit 1 ;; esac \
    && curl -sSfL "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-${HADOLINT_ARCH}" \
       -o /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint

RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin \
    && curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

RUN SONAR_SCANNER_VERSION="$(curl -fsSL https://api.github.com/repos/SonarSource/sonar-scanner-cli/releases/latest | jq -r '.tag_name' | sed 's/^v//')" \
    && ARCH="$(uname -m)" \
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
# Java LSP - Eclipse JDT Language Server
# ---------------------------------------------------------------------
ARG JDTLS_VERSION=1.46.1

RUN mkdir -p /opt/jdtls \
    && curl -fsSL "https://download.eclipse.org/jdtls/milestones/${JDTLS_VERSION}/jdt-language-server-${JDTLS_VERSION}-202504171413.tar.gz" \
       -o /tmp/jdtls.tar.gz \
    && tar -xzf /tmp/jdtls.tar.gz -C /opt/jdtls \
    && rm /tmp/jdtls.tar.gz

RUN cat > /usr/local/bin/jdtls <<'EOF'
#!/usr/bin/env bash
exec /opt/java/jdk21/bin/java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xmx2G \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED \
  -jar /opt/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
  -configuration /opt/jdtls/config_linux \
  -data "${JDTLS_WORKSPACE:-/var/tmp/jdtls-workspace}"
EOF

RUN chmod +x /usr/local/bin/jdtls \
    && mkdir -p /var/tmp/jdtls-workspace \
    && chown -R ${USERNAME}:${USERNAME} /var/tmp/jdtls-workspace

# ---------------------------------------------------------------------
# OpenCode + oh-my-openagent
# ---------------------------------------------------------------------
RUN curl -fsSL https://opencode.ai/install | bash \
    && mv /root/.opencode/bin/opencode /usr/local/bin/opencode


# If this fails, the Docker build fails.
# Non-interactive install for Docker build: no TTY available.
# Enables GitHub Copilot and OpenAI/ChatGPT support.
RUN bunx oh-my-openagent install \
    --no-tui \
    --skip-auth \
    --claude=no \
    --openai=yes \
    --gemini=yes \
    --copilot=yes \
    --opencode-go=no \
    --opencode-zen=no \
    --zai-coding-plan=no \
    --kimi-for-coding=no \
    --vercel-ai-gateway=no

RUN mkdir -p /workspaces \
    && chown ${USERNAME}:${USERNAME} /workspaces

RUN mkdir -p \
    /home/${USERNAME}/.config/opencode \
    /home/${USERNAME}/.local/share/opencode \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local


# ---------------------------------------------------------------------
# Git performance + shell helpers
# ---------------------------------------------------------------------
USER ${USERNAME}

RUN git config --global core.untrackedcache true \
    && git config --global core.fsmonitor true \
    && git config --global feature.manyFiles true \
    && git config --global pull.rebase false

RUN cat >> /home/${USERNAME}/.bashrc <<'EOF'

# Java helpers
alias java8='source /usr/local/bin/use-java8'
alias java21='source /usr/local/bin/use-java21'

# Tomcat helpers
alias t9='start-tomcat9'
alias t11='start-tomcat11'

# Maven helpers
alias mvn8='JAVA_HOME=/opt/java/jdk8 mvn'
alias mvn21='JAVA_HOME=/opt/java/jdk21 mvn'

# Runtime paths
export JAVA8_HOME=/opt/java/jdk8
export JAVA21_HOME=/opt/java/jdk21
export JAVA_HOME=/opt/java/jdk8
export MAVEN_HOME=/opt/maven
export MAVEN_OPTS="-Dmaven.repo.local=/var/tmp/m2/repository"
export TOMCAT9_HOME=/opt/tomcat/tomcat9
export TOMCAT11_HOME=/opt/tomcat/tomcat11
export ACTIVEMQ_HOME=/opt/activemq
export MQ_INSTALLATION_PATH=/opt/mqm
export IBM_MQ_HOME=/opt/mqm
export LD_LIBRARY_PATH="/opt/mqm/lib64:/opt/mqm/lib:${LD_LIBRARY_PATH}"
EOF

WORKDIR /workspaces

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
# Keep these COPY commands at the end so changing instructions/config
# does not invalidate expensive build layers above.
# ---------------------------------------------------------------------

COPY --chown=${USERNAME}:${USERNAME} opencode/opencode.json /home/${USERNAME}/.config/opencode/opencode.json
COPY --chown=${USERNAME}:${USERNAME} opencode/tui.json /home/${USERNAME}/.config/opencode/tui.json
COPY --chown=${USERNAME}:${USERNAME} opencode/instructions.md /home/${USERNAME}/.config/opencode/instructions.md
COPY --chown=${USERNAME}:${USERNAME} opencode/skills/ /home/${USERNAME}/.config/opencode/skills/

EXPOSE 8080 8009 5005 61616 8161

CMD ["bash"]