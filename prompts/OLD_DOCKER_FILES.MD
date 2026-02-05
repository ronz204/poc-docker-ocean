**Server Dockerfile**
```Dockerfile
FROM oven/bun:1.3.5-alpine AS build
WORKDIR /usr/src/app

FROM build AS dependencies
RUN mkdir -p /temp

COPY package.json bun.lock /temp/
RUN cd /temp && bun install --frozen-lockfile --production

FROM build AS release
COPY --from=dependencies /temp/node_modules ./node_modules

RUN apk add --no-cache curl
COPY --chown=bun:bun . .

USER bun
EXPOSE 3000
ENTRYPOINT [ "bun", "run", "prod" ]
```



**Server Service**
```yml
services:
  server:
    build:
      context: .
      dockerfile: dockerfile
    container_name: ocean-server
    restart: unless-stopped
    ports:
      - "3000:3000"
    networks:
      - ocean-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
    depends_on:
      postgres:
        condition: service_healthy
```


**Postgres Service**
```yml
services:
  postgres:
    image: postgres:15-alpine
    container_name: postgres
    restart: unless-stopped
    env_file:
      - ./server/.env
    networks:
      - ocean-network
    volumes:
      - ocean-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U oceanuser -d oceandb"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 15s
```
