.PHONY: dev prod build-dev build-prod down clean ps

up-dev:
	docker compose -f compose.dev.yml up -d

down-dev:
	docker compose -f compose.dev.yml down -v

up-prod:
	docker compose -f compose.prod.yml up -d

down-prod:
	docker compose -f compose.prod.yml down -v

build-dev:
	docker compose -f compose.dev.yml up -d --build

build-prod:
	docker compose -f compose.prod.yml up -d --build
