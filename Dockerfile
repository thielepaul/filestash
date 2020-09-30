FROM node:12-alpine as frontend-build
WORKDIR /build
COPY . .
RUN \
    apk add make git && \
    npm install --silent && \
    make build_frontend

FROM golang:1.12-stretch as backend-build
WORKDIR /build
COPY . . 
RUN \
    apt-get update && \
    apt-get install -y libglib2.0-dev curl make && \
    make build_init && \
    make build_backend

FROM debian:stable-slim
COPY --from=frontend-build /build/dist/data/public /app/data/public
COPY --from=backend-build /build/dist/filestash /app/
COPY config/config.json /app/data/state/config/
RUN \
    apt update && \
    apt install -y libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/* && \
    useradd filestash && \
    chown -R filestash:filestash /app/
USER filestash
EXPOSE 8334
VOLUME ["/app/data/state/"]
WORKDIR "/app"
CMD ["/app/filestash"]
