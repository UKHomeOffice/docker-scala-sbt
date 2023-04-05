#!/usr/bin/env bash

envsubst < /app/.sbt/.credentials.sub > /app/.sbt/.credentials
rm -f /app/.sbt/.credentials.sub
mkdir -p /app/.ivy2/
cp /app/.sbt/.credentials /app/.ivy2/.credentials

export PATH=/app/sbt/bin:$PATH

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

echo "Initialised scala-sbt with PATH: $PATH"

exec "$@"
