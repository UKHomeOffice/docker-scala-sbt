FROM quay.io/ukhomeofficedigital/openjdk8:v1.8.0.161

ENV ACTIVATOR_VER=1.3.10
ENV ACTIVATOR_DIR=typesafe-activator-${ACTIVATOR_VER}
ENV SONAR_SCANNER_VER=3.0.1
ENV PATH=/opt/activator-dist-${ACTIVATOR_VER}/bin:/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}
ENV ARTIFACTORY_USERNAME=user \
    ARTIFACTORY_PASSWORD=pass \
    SBT_CREDENTIALS="/root/.sbt/.credentials" \
    SBT_OPTS="-Dsbt.override.build.repos=true -Dsbt.ivy.home=.ivy2" \
    SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"

RUN yum clean all && \
    yum update -y --exclude iputils* --exclude filesystem* && \
    yum install -y wget curl unzip gettext git && \
    yum clean all && \
    rpm --rebuilddb

#Install sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install sbt -y

# Install activator play
RUN wget -O /tmp/${ACTIVATOR_DIR}.zip \
    https://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VER}/${ACTIVATOR_DIR}.zip && \
    unzip /tmp/${ACTIVATOR_DIR}.zip -d /opt/ && \
    rm -f /tmp/${ACTIVATOR_DIR}.zip

#Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-${SONAR_SCANNER_VER}.zip \
    https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-${SONAR_SCANNER_VER}.zip

RUN mkdir -p /root/.sbt/0.13/plugins/
COPY credentials.sbt /root/.sbt/0.13/plugins/
COPY repositories /root/.sbt
COPY .credentials.sub /root/.sbt/
COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
