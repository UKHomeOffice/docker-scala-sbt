FROM quay.io/ukhomeofficedigital/openjdk11:latest

ENV ARTIFACTORY_USERNAME=user \
    ARTIFACTORY_PASSWORD=pass \
    SBT_CREDENTIALS="/root/.sbt/.credentials" \
    SBT_OPTS="-Dsbt.override.build.repos=true -Dsbt.ivy.home=.ivy2"

RUN yum install -y curl git wget gettext wget

#Install sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install sbt -y

# run sbt sbtVersion (but inside an empty directory due to sbt/sbt#1458)
RUN mkdir -p /tmp/emptyDir
RUN cd /tmp/emptyDir && sbt sbtVersion

RUN mkdir -p /root/.sbt/0.13/plugins/ /root/.sbt/1.0/plugins/
COPY credentials.sbt /root/.sbt/0.13/plugins/
COPY credentials.sbt /root/.sbt/1.0/plugins/
COPY repositories /root/.sbt
COPY .credentials.sub /root/.sbt/
COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]

CMD ["sbt"]
