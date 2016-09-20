#!/usr/bin/env bash

envsubst < /root/.sbt/.credentials.sub > /root/.sbt/.credentials
rm -f /root/.sbt/.credentials.sub
mkdir -p /root/.ivy2/
cp /root/.sbt/.credentials /root/.ivy2/.credentials

CMD=( "${@:1}" )

exec ${CMD[*]}
