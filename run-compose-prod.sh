#!/bin/sh

# The Dockerhub account where the images are stored


# These environment variables come from command line arguments.
# They are consumed by the docker-compose file.
export SECRET_KEY=$1
export DEBUG=$2
export NEW_VERSION=$3
export DOCKERHUB_UNAME=$4
export EMAIL=$5
export GMAIL_APP_PASSWORD=$6
export DB_PORT=$7
export HOST=$8
export POSTGRES_DB=$9
export POSTGRES_USER=${10}
export POSTGRES_PASSWORD=${11}


docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d

# make sure the postgres container is ready, then run migrations
sleep 10 
docker exec boulder_comp-api-1 python /src/manage.py makemigrations 
docker exec boulder_comp-api-1 python /src/manage.py migrate