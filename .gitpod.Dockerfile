FROM gitpod/workspace-base
RUN sudo apt update
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/gitpod/flutter/bin"
RUN flutter channel stable
RUN flutter upgrade
RUN flutter doctor
RUN curl -sL https://firebase.tools | bash