#!/bin/sh
########################################
# Help                                 #
########################################
Help()
{
    #Display Help
    echo "This script runs the docker-compose file."
    echo
    echo "Syntax: run-compose-dev.sh [-h|p]"
    echo "options:"
    echo "h     Print this Help."
    echo "p     Use production environment."
    echo
    echo "Example: ENV_VARIABLE_1=value1 ENV_VARIABLE_2=value2 run-compose-dev.sh"
    echo
    echo "By default, it runs in development environment."
    echo "To run in production environment, pass '-p' flag."
    echo
    exit 1
}
############################################
# Main Program                             #
############################################


#####################################
# I want to write some logic for verifying these are set..
# But that'd be much less messy in an action..
export POSTGRES_DB=$POSTGRES_DB
export POSTGRES_USER=$POSTGRES_USER

export DOCKERHUB_UNAME=$DOCKERHUB_UNAME
export NEW_VERSION=$NEW_VERSION
export HOST=$HOST

export DB_PASS=$DB_PASS

export EMAIL=$EMAIL
export GMAIL_APP_PASSWORD=$GMAIL_APP_PASSWORD

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export BUCKET_NAME=$BUCKET_NAME
#################################
#################################

DEPLOY_ENV="dev"
while getopts ":hp" option; do
    case $option in
        h) # display Help
            Help
            ;;
        p) # set deployment environment to production
            DEPLOY_ENV="prod"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [ "$DEPLOY_ENV" = "prod" ]; then
    docker-compose -f docker-compose.prod.yml down # I think?
    COMPOSE_DOCKER_CLI_BUILD=0 DOCKER_BUILDKIT=0 docker-compose -f docker-compose.prod.yml build --no-cache
    docker-compose -f docker-compose.prod.yml up -d
else
    docker-compose -f docker-compose.dev.yml down
    docker exec boulder_comp-api-1 python /src/manage.py makemigrations
    COMPOSE_DOCKER_CLI_BUILD=0 DOCKER_BUILDKIT=0 docker compose -f docker-compose.dev.yml up -d --build
fi

sleep 10 
# don't need to makemigrations for prod, right? Migrations should already be in repo?
docker exec boulder_comp-api-1 python /src/manage.py migrate