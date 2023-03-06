#!/bin/sh

# Abort on any error.
set -e

# Ensure sh files have unix end line.
dos2unix *.sh

docker compose down -v --remove-orphans
docker builder prune -f
docker system prune -f
docker compose up -d --build

MSYS_NO_PATHCONV=1 \
docker compose exec quarkus-lab /bin/bash