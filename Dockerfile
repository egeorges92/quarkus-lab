FROM ubuntu:20.04

ENV JAVA_VERSION=17
ENV GRAALVM_VERSION=22.3.1
ENV DOCKER_VERSION=20.10.22

RUN apt-get update

# Add mandatory librairies and tools
RUN apt-get install -y \
    build-essential \
    libz-dev \
    wget \
    zlib1g-dev

# Install GraalVM

RUN mkdir /opt/jvm
RUN cd /opt/jvm
WORKDIR /opt/jvm

RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.1/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz \
         -o /opt/jvm/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz; \
         tar -xzf graalvm-ce-java17-linux-amd64-22.3.1.tar.gz; \
         rm /opt/jvm/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz

ENV JAVA_HOME=/opt/jvm/graalvm-ce-java17-22.3.1
ENV PATH=/opt/jvm/graalvm-ce-java17-22.3.1/bin:$PATH

# Install Docker

RUN apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN mkdir -m 0755 -p /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null; \
    apt-get update; \
    apt-get install -y docker-ce-cli docker-buildx-plugin docker-compose-plugin

# Install Quarkus
RUN curl -Ls https://sh.jbang.dev | bash -s - trust add https://repo1.maven.org/maven2/io/quarkus/quarkus-cli/; \
    curl -Ls https://sh.jbang.dev | bash -s - app install --fresh --force quarkus@quarkusio


VOLUME [ "/workspace", "/root/.m2" ]
WORKDIR /workspace
EXPOSE 8080

CMD ["sh", "-c", "tail -f /dev/null"]