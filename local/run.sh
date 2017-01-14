#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

docker network create maracas

echo "Running emacs container"
docker run -d --name emacs --net maracas -p 5900:5900 gigawhitlocks/emacs:latest
#5900:5900
echo "Running guacd"
docker run -d --name guacd --net maracas -p 4822:4822 guacamole/guacd:latest
#-p 4822:4822
echo "Run guacamole"
docker run -d --name guacamole -p 8080:8080 --network=maracas gigawhitlocks/local-guac:latest

docker ps
echo -e "\n\n####\nSuccess!\nOpen to http://localhost:8080/guacamole in a browser or connect a vnc viewer to localhost:5900"
