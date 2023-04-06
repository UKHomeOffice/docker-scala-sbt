FROM quay.io/centos/centos:stream8

RUN yum clean all
RUN yum -y update
RUN yum -y install curl git wget gettext wget fontconfig glibc-langpack-en

# Install the 3 LTE supported JDK's 8, 11 and 17
RUN yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-src.x86_64 java-11-openjdk.x86_64 java-11-openjdk-src.x86_64 java-17-openjdk.x86_64 java-17-openjdk-src.x86_64

RUN groupadd -r app -g 1000 && \
    useradd -r -g app -u 1000 app -d /app && \
    mkdir -p /app && \
    chown -R app:app /app

WORKDIR /app

# Download and install SBT. Use a fixed version, but of course, sbt will fetch
# the version associated with the project.
RUN wget https://github.com/sbt/sbt/releases/download/v1.8.2/sbt-1.8.2.tgz
RUN tar -xvf sbt-1.8.2.tgz

ENV PATH="/app/sbt/bin:$PATH"

RUN mkdir -p /app/.sbt /app/.ivy2
COPY repositories /app/.sbt/repositories
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
