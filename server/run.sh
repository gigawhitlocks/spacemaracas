#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

docker network create maracas

echo "Running emacs container"
docker run -d --name some-emacs -p 5900:5900 --net maracas gigawhitlocks/emacs:latest

echo "Running guacd"
docker run --name some-guacd -d -p 4822:4822 --net maracas guacamole/guacd:latest

echo "Preparing database"
./guac_postgres.sh

echo "Running guacamole"
docker run --name some-guacamole --net maracas \
       -e POSTGRES_DATABASE=guacamole_db  \
       -e POSTGRES_USER=guacamole_user    \
       -e POSTGRES_PASSWORD=some_password \
       -d -p 8080:8080 guacamole/guacamole:latest

docker ps
echo -e "\n\n####\nSuccess!\nOpen to http://localhost:8080/guacamole in a browser or connect a vnc viewer to localhost:5900"
