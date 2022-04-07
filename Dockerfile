FROM golang:1.18.0-bullseye
WORKDIR /app
COPY . .
ENTRYPOINT ["go","run","server.go"]