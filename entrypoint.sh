#!/usr/bin/env bash

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

echo "-java-home $JAVA_HOME" >> /app/sbt/conf/sbtopts

# Set ACP Artefactory as the proxy for dependency resolution
echo -en "realm=Artifactory Realm\nhost=artifactory.digital.homeoffice.gov.uk\nuser=$ARTIFACTORY_USERNAME\npassword=$ARTIFACTORY_PASSWORD" > /app/.ivy2/.credentials
mkdir /root/.ivy2
cp /app/.ivy2/.credentials /root/.ivy2/.credentials

exec "$@"
