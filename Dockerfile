FROM quay.io/centos/centos:stream8

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/CentOS-*.repo
RUN sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/CentOS-*.repo
RUN sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/CentOS-*.repo

RUN dnf clean all
RUN dnf -y update
RUN dnf -y install curl git wget gettext wget fontconfig glibc-langpack-en

# Install all the LTE supported JDKs
RUN dnf -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-src.x86_64 java-11-openjdk.x86_64 java-11-openjdk-src.x86_64 java-17-openjdk.x86_64 java-17-openjdk-src.x86_64 java-21-openjdk.x86_64 java-21-openjdk-src.x86_64 

RUN groupadd -r app -g 1000 && \
    useradd -r -g app -u 1000 app -d /app && \
    mkdir -p /app && \
    chown -R app:app /app

WORKDIR /app

# Download and install SBT. Use a fixed version, but of course, sbt will fetch
# the version associated with the project.
RUN wget https://github.com/sbt/sbt/releases/download/v1.10.11/sbt-1.10.11.tgz
RUN tar -xvf sbt-1.10.11.tgz

RUN mkdir -p /app/.sbt /app/.ivy2
COPY repositories /app/.sbt/repositories
COPY entrypoint.sh /app/entrypoint.sh

ENV LANGUAGE=en_GB:en
ENV GDM_LANG=en_GB.utf8
ENV LANG=en_GB.UTF-8
ENV SBT_CREDENTIALS="/app/.ivy2/.credentials"
ENV SBT_OPTS="-Duser.home=/app -Dsbt.override.build.repos=true -Dsbt.ivy.home=/app/.ivy2"

ENTRYPOINT ["/app/entrypoint.sh"]
