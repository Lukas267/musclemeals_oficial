FROM mcr.microsoft.com/devcontainers/base:jammy
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=${FLUTTER_HOME}/bin:${PATH}

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    flutter precache

# Accept Flutter licenses
RUN yes | flutter doctor --android-licenses

CMD ["bash"]
RUN flutter doctor
