FROM node:12-alpine as frontend-build
WORKDIR /build
COPY . .
RUN apk add make git && \
    npm install --silent && \
    make build_frontend

FROM golang:latest as backend-build
WORKDIR /build
COPY . . 
COPY --from=frontend-build /build/server/ctrl/static /build/server/ctrl/static
RUN make build_init build_backend

FROM gcr.io/distroless/static-debian11:latest
COPY --from=backend-build /build/dist/filestash /app/
COPY config/config.json /app/data/state/config/
EXPOSE 8334
WORKDIR "/app"
CMD ["/app/filestash"]
