FROM quay.io/ukhomeofficedigital/scala-sbt:latest

ENV ARTIFACTORY_USERNAME=user \
    ARTIFACTORY_PASSWORD=pass \
    SBT_CREDENTIALS="/root/.sbt/.credentials" \
    SBT_OPTS="-Dsbt.override.build.repos=true -Dsbt.ivy.home=.ivy2"


# Install Scala.js dependencies
RUN \
  curl -sL https://raw.githubusercontent.com/nodesource/distributions/master/rpm/setup_6.x | bash - && \
  yum install -y nodejs && \
  npm install jsdom@v9 source-map-support

# Install yarn
RUN \
   curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
   yum install -y yarn && \
  


ENTRYPOINT ["/root/entrypoint.sh"]
