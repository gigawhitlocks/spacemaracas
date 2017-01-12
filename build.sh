#/bin/bash

echo "Building emacs container"
docker build -t emacs .

echo "Build custom guacamole"
docker build -t guac ./guacamole
