#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# echo "Building emacs container"
# docker build -t emacs .

echo "Running emacs container"
docker run --rm -d --name some-emacs -p 5900:5900 gigawhitlocks/emacs:latest

echo "Running guacd"
docker run --rm --name some-guacd -d -p 4822:4822 --link some-emacs:emacs guacamole/guacd:latest

# echo "Generate SQL init script"
# docker run guacamole/guacamole:latest /opt/guacamole/bin/initdb.sh --postgres > initdb.sql

# echo "Starting postgres"
# docker run --name guac-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
# sleep 5

# echo "Create guacamole db"
# docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
#        psql -h postgres -U postgres -c "CREATE DATABASE guacamole_db;"

# echo "Run SQL init script against the db"
# docker run -e PGPASSWORD=mysecretpassword -v $(pwd):/tmp --rm --link guac-postgres:postgres postgres \
#        psql -h postgres -U postgres -d "guacamole_db" -f /tmp/initdb.sql

# echo "Create roles"
# docker run -e PGPASSWORD=mysecretpassword --rm --link guac-postgres:postgres postgres\
#        psql -h postgres -U postgres -d "guacamole_db" -c \
#        "CREATE USER guacamole_user WITH PASSWORD 'some_password';
#        GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;
#        GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;"

# echo "Build custom guacamole"
# docker build -t guac ./guacamole

echo "Run guacamole"

           # # --link guac-postgres:postgres      \
           #     -e POSTGRES_DATABASE=guacamole_db  \
           #        -e POSTGRES_USER=guacamole_user    \
           #        -e POSTGRES_PASSWORD=some_password \

docker run --rm --name some-guacamole\
       --link some-guacd:guacd \
       --link some-emacs:emacs \
       -d -p 8080:8080 gigawhitlocks/guac:latest

docker ps
echo -e "\n\n####\nSuccess!\nOpen to localhost:8080 in a browser or connect a vnc viewer to localhost:5900"
