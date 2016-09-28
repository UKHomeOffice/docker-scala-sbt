#!/usr/bin/env bash

envsubst < /root/.sbt/.credentials.sub > /root/.sbt/.credentials
rm -f /root/.sbt/.credentials.sub
mkdir -p /root/.ivy2/
cp /root/.sbt/.credentials /root/.ivy2/.credentials

if [ ${USE_COURSIER} == "true" ]
then
  mkdir -p /root/.sbt/0.13/plugins/
  echo 'addSbtPlugin("io.get-coursier" % "sbt-coursier" % "1.0.0-M14")' > /root/.sbt/0.13/plugins/build.sbt
fi

CMD=( "${@:1}" )

exec ${CMD[*]}
