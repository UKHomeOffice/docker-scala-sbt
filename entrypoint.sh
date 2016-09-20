#!/usr/bin/env bash

envsubst < /root/.ivy2/.credentials.sub > /root/.ivy2/.credentials
rm -f /root/.ivy2/.credentials.sub

CMD=( "$@" )

exec ${CMD[*]}
