# Need to add api key and url environment variables?

export SECRET_KEY=abc123
export DEBUG=True
export POSTGRES_DB=roll_track
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export EMAIL=kendbonnette@gmail.com
export GMAIL_APP_PASSWORD="vnhx rzwo owhq retc"



COMPOSE_DOCKER_CLI_BUILD=0 DOCKER_BUILDKIT=0 docker compose -f docker-compose.dev.yml up -d --build

# make sure the postgres container is ready, then run migrations
sleep 10
docker exec boulder_comp-api-1 python /src/manage.py makemigrations 
docker exec boulder_comp-api-1 python /src/manage.py migrate