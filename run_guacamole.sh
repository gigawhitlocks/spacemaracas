#!/bin/bash

docker run --name some-guacd -d -p 4822:4822 guacamole/guacd
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > initdb.sql

echo starting postgres
docker run --name guac-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
sleep 5

docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -c "CREATE DATABASE guacamole_db;"

docker run -e PGPASSWORD=mysecretpassword -v $(pwd):/tmp --rm --link guac-postgres:postgres postgres \
       psql -h postgres -U postgres -d "guacamole_db" -f /tmp/initdb.sql

docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -d "guacamole_db" -c \
       "CREATE USER guacamole_user WITH PASSWORD 'some_password';"

docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -d "guacamole_db" -c \
       "GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;"
docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -d "guacamole_db" -c \
       "GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;"

docker run --name some-guacamole --link some-guacd:guacd \
       --link guac-postgres:postgres      \
       -e POSTGRES_DATABASE=guacamole_db  \
       -e POSTGRES_USER=guacamole_user    \
       -e POSTGRES_PASSWORD=some_password \
       -d -p 8080:8080 guacamole/guacamole
