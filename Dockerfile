FROM quay.io/ukhomeofficedigital/centos-base:v0.2.0

RUN yum clean all && \
    yum update -y && \
    yum install -y wget curl unzip && \
    yum clean all && \
    rpm --rebuilddb

# Download and Install Oracle JDK
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm -O /tmp/java.rpm && \
    rpm -ivh /tmp/java.rpm

#Install sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install sbt -y

# Install activator play
ENV ACTIVATOR_VER 1.3.6
ENV ACTIVATOR_DIR typesafe-activator-${ACTIVATOR_VER}

RUN wget -O /tmp/${ACTIVATOR_DIR}.zip \
      https://downloads.typesafe.com/typesafe-activator/1.3.6/${ACTIVATOR_DIR}.zip && \
    cd && unzip /tmp/${ACTIVATOR_DIR}.zip -d /opt/${ACTIVATOR_DIR} && \
    rm /tmp/${ACTIVATOR_DIR}.zip

ENV PATH /opt/activator-dist-${ACTIVATOR_VER}:$PATH
