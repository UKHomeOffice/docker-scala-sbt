#!/usr/bin/env bash

# Add sbt to the PATH
export PATH="/app/sbt/bin:$PATH"

# Select project's desired JDK and configure it
case $JRE_VERSION in

  "8")
    export JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk/
    ;;
  "11")
    export JAVA_HOME=/etc/alternatives/jre_11_openjdk/
    ;;
  "17")
    export JAVA_HOME=/etc/alternatives/jre_17_openjdk/
    ;;
esac

export JRE_HOME=$JAVA_HOME/jre
export PATH=$JAVA_HOME/bin:$PATH

# Set ACP Artefactory as the proxy for dependency resolution
echo -en "realm=Artifactory Realm\nhost=artifactory.digital.homeoffice.gov.uk\nuser=$ARTIFACTORY_USERNAME\npassword=$ARTIFACTORY_PASSWORD" > /app/.ivy2/.credentials
export SBT_CREDENTIALS="/app/.ivy2/.credentials"
export SBT_OPTS="-Duser.home=/app -Dsbt.override.build.repos=true -Dsbt.ivy.home=/app/.ivy2"

exec "$@"
