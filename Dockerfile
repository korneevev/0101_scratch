# Start by building the application.
FROM scratch as build

WORKDIR /go/src/app
COPY . .

VOLUME /upload

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go
