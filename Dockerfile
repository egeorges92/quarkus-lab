FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV JAVA_VERSION=17
ENV GRAALVM_VERSION=22.3.1
ENV DOCKER_VERSION=20.10.22

RUN apt-get update
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install GraalVM and Quarkus

RUN apt-get install -y \
    build-essential \
    curl \
    libz-dev \
    unzip \
    zip \
    zlib1g-dev

RUN curl -s "https://get.sdkman.io" | bash

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" \
    && sdk install java 22.3.1.r19-grl \
    && sdk install quarkus 2.16.4.Final \
    && gu install native-image \
    && echo "source <(quarkus completion)" >> ~/.bashrc

# Install Docker

RUN apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && mkdir -m 0755 -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin

# Install nginx to provide Healthceck and maintain the container up and running.
RUN apt-get install  -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/sites-available/default

COPY docker-entrypoint.sh .

VOLUME [ "/workspace", "/root/.m2" ]
WORKDIR /workspace
EXPOSE 80
EXPOSE 8080

STOPSIGNAL SIGQUIT
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
