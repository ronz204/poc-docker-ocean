.PHONY: dev prod build-dev build-prod down clean ps

up-dev:
	docker compose -f compose.yml -f ./docker/compose.dev.yml up -d

up-prod:
	docker compose -f compose.yml -f ./docker/compose.prod.yml up -d

build-dev:
	docker compose -f compose.yml -f ./docker/compose.dev.yml up -d --build

build-prod:
	docker compose -f compose.yml -f ./docker/compose.prod.yml up -d --build

down:
	docker compose down

ps:
	docker compose ps

clean:
	docker compose down -v
	docker rmi ocean-elysia
