.PHONY: dev prod down clean ps

dev:
	docker compose -f compose.yml -f ./docker/compose.dev.yml up -d

prod:
	docker compose -f compose.yml -f ./docker/compose.prod.yml up -d

down:
	docker compose down

ps:
	docker compose ps

clean:
	docker compose down -v
