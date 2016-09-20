FROM quay.io/ukhomeofficedigital/centos-base:v0.3.0

RUN yum clean all && \
    yum update -y && \
    yum install -y wget curl unzip gettext && \
    yum clean all && \
    rpm --rebuilddb

# Download and Install Oracle JDK
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm -O /tmp/java.rpm && \
    rpm -ivh /tmp/java.rpm && rm -rf /tmp/java.rpm

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip -O /tmp/jce.zip && \
    unzip /tmp/jce.zip -d /tmp && \
    cp -f /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/java/jdk1.8.0_101/jre/lib/security/. && \
    rm -rf /tmp/jce.zip /tmp/UnlimitedJCEPolicyJDK8

#Install sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install sbt -y

# Install activator play
ENV ACTIVATOR_VER 1.3.10
ENV ACTIVATOR_DIR typesafe-activator-${ACTIVATOR_VER}

RUN wget -O /tmp/${ACTIVATOR_DIR}.zip \
      https://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VER}/${ACTIVATOR_DIR}.zip && \
    cd && unzip /tmp/${ACTIVATOR_DIR}.zip -d /opt/ && \
    rm /tmp/${ACTIVATOR_DIR}.zip

RUN alternatives --set java /usr/java/jdk1.8.0_101/jre/bin/java

ENV PATH=/opt/activator-dist-${ACTIVATOR_VER}:$PATH \
    ARTIFACTORY_USERNAME=user \
    ARTIFACTORY_PASSWORD=pass \
    SBT_CREDENTIALS="/root/.ivy2/.credentials" \
    SBT_OPTS="-Dsbt.override.build.repos=true"

RUN mkdir -p /root/.ivy2 && mkdir -p /root/.sbt/0.13/plugins/
COPY credentials.sbt /root/.sbt/0.13/plugins/
COPY repositories /root/.sbt
COPY .credentials.sub /root/.ivy2/

ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["help"]
