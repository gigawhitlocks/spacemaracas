#!/bin/bash

docker tag emacs gigawhitlocks/emacs:latest
docker push gigawhitlocks/emacs:latest

docker tag guac gigawhitlocks/guac:latest
docker push gigawhitlocks/guac:latest
