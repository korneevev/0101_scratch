# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/src/app/scratch cmd/main.go

RUN echo "appuser:x:65534:65534:Appuser:/:" > /etc_passwd

FROM scratch
VOLUME /upload

WORKDIR /
COPY --from=build /etc_passwd /etc/passwd
COPY --from=build /go/src/app/scratch .

USER appuser
EXPOSE 9999