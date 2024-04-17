# Use a base image with Ubuntu
FROM ubuntu:20.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install basics
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \ 
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set up new user for GitHub Codespace
ARG USERNAME=codespace
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Switch to user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git \
    && cd flutter \
    && git checkout 3.7.1
    
ENV PATH="/home/$USERNAME/flutter/bin:${PATH}"

# Run basic check to download Dart SDK
RUN flutter doctor

# Install Flutter version 3.7

# Set Flutter and Dart SDK path
ENV PATH="$PATH:/home/$USERNAME/flutter/bin:/home/$USERNAME/.pub-cache/bin"

# Pre-download development binaries and packages
RUN flutter precache

# Set work directory for Codespaces
WORKDIR /workspace

# Cleanup unnecessary files and clear cache
RUN sudo apt-get autoremove -y \
    && sudo apt-get clean -y \
    && sudo rm -rf /var/lib/apt/lists/*

# Expose any ports needed by your application, for example:
# EXPOSE 8080

CMD ["bash"]
