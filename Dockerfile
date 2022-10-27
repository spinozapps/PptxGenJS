FROM node:16.9.1-bullseye-slim

RUN mkdir /app
WORKDIR /app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY package.json package-lock.json /app/
RUN npm ci

COPY . /app
RUN npm run ship

RUN \
  echo '#!/usr/bin/env bash' >> /usr/bin/npm-entrypoint && \
  echo 'set -e' >> /usr/bin/npm-entrypoint && \
  echo 'echo //registry.npmjs.org/:_authToken=${NPM_TOKEN} > ~/.npmrc' >> /usr/bin/npm-entrypoint && \
  echo 'exec "$@"' >> /usr/bin/npm-entrypoint && \
  chmod +x /usr/bin/npm-entrypoint
ENTRYPOINT ["/usr/bin/npm-entrypoint"]
