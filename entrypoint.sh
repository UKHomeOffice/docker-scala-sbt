#!/usr/bin/env bash

envsubst < /root/.ivy2/.credentials.sub > /root/.ivy2/.credentials
rm -f /root/.ivy2/.credentials.sub

if [[ "clean update" =~ $1 ]]; then
    CMD="sbt "
    CMD+=( "${@:1}" )
else
    CMD=( "$@" )
fi

exec ${CMD[*]}
