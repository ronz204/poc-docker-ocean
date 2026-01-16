FROM oven/bun:1.3.5-alpine AS build
WORKDIR /usr/src/app

FROM build AS install
RUN mkdir -p /temp/prod

COPY package.json bun.lock /temp/prod/
RUN cd /temp/prod && bun install --frozen-lockfile --production

FROM build AS release
COPY --from=install /temp/prod/node_modules ./node_modules

COPY . .
USER bun
EXPOSE 3000
ENTRYPOINT [ "bun", "run", "prod" ]
