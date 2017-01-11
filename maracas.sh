#!/bin/bash

echo "Building emacs container"
docker build -t emacs .

echo "Running emacs container"
docker run -d --name some-emacs -p 5900:5900 emacs

echo "Running guacd"
docker run --name some-guacd -d -p 4822:4822 --link some-emacs:emacs guacamole/guacd

echo "Generate SQL init script"
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > initdb.sql

echo "Starting postgres"
docker run --name guac-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
sleep 5

echo "Create guacamole db"
docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -c "CREATE DATABASE guacamole_db;"

echo "Run SQL init script against the db"
docker run -e PGPASSWORD=mysecretpassword -v $(pwd):/tmp --rm --link guac-postgres:postgres postgres \
       psql -h postgres -U postgres -d "guacamole_db" -f /tmp/initdb.sql

echo "Create roles"
docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
       psql -h postgres -U postgres -d "guacamole_db" -c \
       "CREATE USER guacamole_user WITH PASSWORD 'some_password';
       GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;
       GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;"

echo "Run guacamole"
docker run --name some-guacamole --link some-guacd:guacd \
       --link guac-postgres:postgres      \
       --link some-emacs:emacs \
       -e POSTGRES_DATABASE=guacamole_db  \
       -e POSTGRES_USER=guacamole_user    \
       -e POSTGRES_PASSWORD=some_password \
       -d -p 8080:8080 guacamole/guacamole:latest

docker ps
echo -e "####\nSuccess!\nOpen to localhost:8080 in a browser or connect a vnc viewer to localhost:5900"
