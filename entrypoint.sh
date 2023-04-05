#!/usr/bin/env bash

envsubst < /app/.sbt/.credentials.sub > /app/.sbt/.credentials
rm -f /app/.sbt/.credentials.sub
mkdir -p /app/.ivy2/
cp /app/.sbt/.credentials /app/.ivy2/.credentials

exec "$@"
