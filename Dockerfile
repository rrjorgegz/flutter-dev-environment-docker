# Flutter Development Environment Docker Image
# Based on Ubuntu for better compatibility with Flutter toolchain

FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set Flutter version - can be overridden at build time
ARG FLUTTER_VERSION=stable

# Set environment variables
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Install required dependencies
RUN apt-get update && apt-get install -y \
    # Core utilities
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    # Required for Flutter web development
    wget \
    # Required for building Flutter apps
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    # Java JDK (required by some Flutter tools and can be used for Android development setup)
    openjdk-17-jdk \
    # Additional tools
    ca-certificates \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Set locale to UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Download and install Flutter SDK
# Clone the repository first, then checkout the specified version (works for both branches and tags)
# SSL verification is enabled by default in git
RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    cd ${FLUTTER_HOME} && \
    git checkout ${FLUTTER_VERSION}

# Pre-download Flutter dependencies and disable analytics
# Using || true for flutter doctor to prevent build failures due to missing optional components
RUN flutter config --no-analytics && \
    flutter precache && \
    (flutter doctor || true)

# Create a non-root user for development
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} developer && \
    useradd -m -u ${USER_ID} -g developer -s /bin/bash developer && \
    mkdir -p /app && \
    chown -R developer:developer /app && \
    chown -R developer:developer ${FLUTTER_HOME}

# Set up working directory
WORKDIR /app

# Switch to non-root user
USER developer

# Set default command
CMD ["bash"]
