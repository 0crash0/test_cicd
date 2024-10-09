# build environment
FROM node:22.9.0-alpine3.20 as build

ARG CONFIGFILENAME=main.cfg

WORKDIR /app
COPY . /app
RUN npm install
RUN npm run build
COPY ${CONFIGFILENAME} /app/dist/

# production environment
FROM alpine:3.20.3
COPY --from=build /app/dist /var/www/html/
