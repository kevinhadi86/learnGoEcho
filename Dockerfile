FROM golang:1.18.0-bullseye
COPY . .
ENTRYPOINT ["go","run","server.go"]