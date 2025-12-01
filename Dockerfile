FROM ubuntu:22.04

# Arguments and environment variables
ARG BUILD_TOOLS_VERSION=35.0.0
ARG PLATFORM_VERSION=35
ARG COMMAND_LINE_VERSION=latest
ARG URL_COMMAND_LINE_TOOLS=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# Installing necessary dependencies
RUN apt update && apt install -y \
    curl \
    git \
    unzip \
    openjdk-8-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Configuring the working directory and user to use
ARG USER=root
USER $USER
WORKDIR /home/$USER

# Prepare environment
ENV ANDROID_HOME=/home/$USER/Android/sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME/cmdline-tools
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Creating Android directories
RUN mkdir -p $ANDROID_HOME
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg

# Download Android Command Line Tools
RUN wget -O commandlinetools.zip $URL_COMMAND_LINE_TOOLS && \
    unzip commandlinetools.zip -d $ANDROID_HOME && \
    rm commandlinetools.zip

# Create the cmdline-tools directory structure expected by SDK manager
RUN mkdir -p $ANDROID_SDK_ROOT/latest && \
    mv $ANDROID_SDK_ROOT/* $ANDROID_SDK_ROOT/latest/ || true

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git

# Accept licenses and install Android SDK components
RUN yes | $ANDROID_SDK_ROOT/latest/bin/sdkmanager --licenses
RUN $ANDROID_SDK_ROOT/latest/bin/sdkmanager \
    "build-tools;${BUILD_TOOLS_VERSION}" \
    "platform-tools" \
    "platforms;android-${PLATFORM_VERSION}" \
    "emulator"

# Setup PATH environment variable
ENV PATH="$PATH:/home/$USER/flutter/bin"

# Verify the status licenses and Flutter setup
RUN flutter doctor --android-licenses

# Start the adb daemon
RUN $ANDROID_HOME/platform-tools/adb start-server