# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o app cmd/main.go
RUN ls /go/src/app

RUN echo "appuser:x:65534:65534:Appuser:/:" > /etc_passwd

FROM scratch
VOLUME /upload

COPY --from=0 /etc_passwd /etc/passwd

COPY --from=build /go/src/app/app .
RUN ls

USER appuser

EXPOSE 9999

ENTRYPOINT ["/app"]