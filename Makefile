.PHONY: up-dev down-dev up-prod down-prod build-dev build-prod

up-dev:
	docker compose -f compose.dev.yml up --watch

down-dev:
	docker compose -f compose.dev.yml down -v

up-prod:
	docker compose -f compose.prod.yml up

down-prod:
	docker compose -f compose.prod.yml down -v

build-dev:
	docker compose -f compose.dev.yml up -d --build

build-prod:
	docker compose -f compose.prod.yml up -d --build
