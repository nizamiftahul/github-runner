# Dockerfile
FROM ubuntu:22.04

ARG RUNNER_VERSION=2.333.0
ARG RUNNER_ARCH=x64

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    git \
    ca-certificates \
    jq \
    # Docker dependencies
    docker.io \
    # Node.js untuk beberapa actions
    nodejs \
    npm \
    # Python
    python3 \
    python3-pip \
    # Bash utilities
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create runner directory
WORKDIR /home/runner

# Download actions-runner
RUN curl -o actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

# Extract
RUN tar xzf ./actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

# Install dependencies
RUN ./bin/installdependencies.sh

# Create runner user
RUN useradd -m -s /bin/bash runner && \
    usermod -aG docker runner && \
    chown -R runner:runner /home/runner

# Allow runner to use sudo without password (untuk docker)
RUN echo "runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to runner user
USER runner

# Copy entrypoint
COPY --chown=runner:runner entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ps aux | grep -q "[r]un.sh" || exit 1

ENTRYPOINT ["/home/runner/entrypoint.sh"]