#!/bin/bash

echo "Building emacs container"
docker build -t maracas-emacs .
docker tag maracas-emacs gigawhitlocks/emacs:latest

echo "Build base for custom guacamoles"
docker build -t guac ../guacamole
docker tag guac gigawhitlocks/guacamole:latest

echo "Build local guacamole"
docker build -t local-guac ./guacamole
docker tag local-guac gigawhitlocks/local-guac:latest
