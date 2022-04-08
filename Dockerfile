FROM node:16-alpine

WORKDIR /home/node/app

RUN apk update && \
    apk add git build-base autoconf automake libtool pkgconfig nasm

COPY package.json *.lock ./
RUN yarn install

COPY . .

ENTRYPOINT ["./docker-entrypoint.sh"]
