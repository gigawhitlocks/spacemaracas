#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if test ! $(env | grep MARACAS_DB_PASS); then
    echo "Set MARACAS_DB_PASS=yoursecretpassword to initialize the user database with the password set in that variable. This variable must be set."
    exit 1
fi

echo "Generating SQL init script"
docker run --rm guacamole/guacamole:latest /opt/guacamole/bin/initdb.sh --postgres > initdb.sql

echo "Starting postgres"
docker run --name guac-postgres -e POSTGRES_PASSWORD="$MARACAS_DB_PASSWORD" -d postgres
sleep 5

echo "Create guacamole db"
docker run -e PGPASSWORD="$MARACAS_DB_PASSWORD" --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -c "CREATE DATABASE guacamole_db;"

echo "Run SQL init script against the db"
docker run -e PGPASSWORD="$MARACAS_DB_PASSWORD" -v $(pwd):/tmp --rm --link guac-postgres:postgres postgres \
       psql -h postgres -U postgres -d "guacamole_db" -f /tmp/initdb.sql

echo "Create roles"
docker run -e PGPASSWORD="$MARACAS_DB_PASSWORD" --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -d "guacamole_db" -c \
       "CREATE USER guacamole_user WITH PASSWORD 'some_password';
       GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;
       GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;"
