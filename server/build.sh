#!/bin/bash

docker build -t guac-multi ./guacamole
docker tag guac-multi gigawhitlocks/guac-multi:latest
