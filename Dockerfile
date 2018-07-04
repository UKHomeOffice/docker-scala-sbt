FROM quay.io/ukhomeofficedigital/openjdk8:latest

ENV ARTIFACTORY_USERNAME=user \
    ARTIFACTORY_PASSWORD=pass \
    SBT_CREDENTIALS="/root/.sbt/.credentials" \
    SBT_OPTS="-Dsbt.override.build.repos=true -Dsbt.ivy.home=.ivy2"

RUN yum clean all && \
    yum update -y --exclude iputils* --exclude filesystem* && \
    yum install -y wget curl unzip gettext git && \
    yum clean all && \
    rpm --rebuilddb

#Install sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install sbt -y

# Install Scala.js dependencies
RUN \
  curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
  curl -sL https://raw.githubusercontent.com/nodesource/distributions/master/rpm/setup_6.x | bash - && \
  yum install -y nodejs && \
  yum install -y yarn && \
  npm install jsdom@v9 source-map-support


RUN mkdir -p /root/.sbt/0.13/plugins/
COPY credentials.sbt /root/.sbt/0.13/plugins/
COPY repositories /root/.sbt
COPY .credentials.sub /root/.sbt/
COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
