#!/usr/bin/env bash

set -e

echo "Starting entry_point.sh script..."

sleep 10

source variables.sh

# ./scripts/pgsql_restore.sh 2024-08-19.dump $POSTGRES_USER $POSTGRES_PASSWORD
./scripts/pgsql_restore.sh data.dump user password

cd /usr/local/tomcat/bin

./catalina.sh run