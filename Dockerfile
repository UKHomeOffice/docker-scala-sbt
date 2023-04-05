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

USER 1000
WORKDIR /app

# Download and install SBT. Use a fixed version, but of course, sbt will fetch
# the version associated with the project.
RUN wget https://github.com/sbt/sbt/releases/download/v1.8.2/sbt-1.8.2.tgz
RUN tar -xvf sbt-1.8.2.tgz

ENV SBT_CREDENTIALS="/app/.sbt/.credentials"
ENV SBT_OPTS="-Dsbt.override.build.repos=true -Dsbt.ivy.home=.ivy2"
ENV PATH="/app/sbt/bin:$PATH"

RUN mkdir -p /app/.sbt/0.13/plugins/ /app/.sbt/1.0/plugins/
COPY credentials.sbt /app/.sbt/0.13/plugins/
COPY credentials.sbt /app/.sbt/1.0/plugins/
COPY repositories /app/.sbt
COPY .credentials.sub /app/.sbt/

COPY setjdk /app/setjdk
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
