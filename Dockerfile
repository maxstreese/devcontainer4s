FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update                       && \
    apt-get install --quiet --assume-yes    \
    curl                                    \
    git-all                                 \
    unzip                                   \
    zip

RUN  curl -s "https://get.sdkman.io" | bash

COPY .sdkman/etc/config /root/.sdkman/etc/config

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk update                                && \
    sdk install java 21.1.0.r11-grl           && \
    sdk install maven 3.8.1                   && \
    sdk install scala 2.13.5                  && \
    sdk install sbt 1.5.2

RUN mkdir /root/.jdk                                                  && \
    ln -s /root/.sdkman/candidates/java/21.1.0.r11-grl/ /root/.jdk/11

RUN curl -L https://git.io/coursier-cli-linux > /usr/local/bin/cs && \
    chmod +x /usr/local/bin/cs

ENV PATH="$PATH:/root/.local/share/coursier/bin"

RUN cs install bloop --only-prebuilt=true

COPY .sbt/1.0/plugins/build.sbt /root/.sbt/1.0/plugins/build.sbt

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    mkdir dummy-sbt-project                   && \
    cd dummy-sbt-project                      && \
    sbt -version                              && \
    cd -                                      && \
    rm -rf dummy-sbt-project/

RUN source "$HOME/.sdkman/bin/sdkman-init.sh"                                                               && \
    curl -L https://github.com/com-lihaoyi/Ammonite/releases/download/2.3.8/2.13-2.3.8 > /usr/local/bin/amm && \
    chmod +x /usr/local/bin/amm

COPY .ammonite/predef.sc /root/.ammonite/predef.sc

WORKDIR /root

ENV DEBIAN_FRONTEND="dialog"
