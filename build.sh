#!/bin/bash

echo "Building emacs container"
docker build -t emacs .
docker tag emacs gigawhitlocks/emacs:latest

echo "Build custom guacamole"
docker build -t guac ./guacamole
docker tag guac gigawhitlocks/guac:latest
