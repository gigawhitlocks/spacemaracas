#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# echo "Building emacs container"
# docker build -t emacs .

echo "Running emacs container"
docker run -d --name some-emacs -p 5900:5900 gigawhitlocks/emacs:latest

echo "Running guacd"
docker run --name some-guacd -d -p 4822:4822 --link some-emacs:emacs guacamole/guacd:latest

echo "Run guacamole"

docker run --name some-guacamole\
       --link some-guacd:guacd \
       --link some-emacs:emacs \
       -d -p 8080:8080 gigawhitlocks/guac:latest

docker ps
echo -e "\n\n####\nSuccess!\nOpen to http://localhost:8080 in a browser or connect a vnc viewer to localhost:5900"
