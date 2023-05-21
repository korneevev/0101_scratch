# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o app cmd/main.go
RUN ls
RUN ls /go/src/app
RUN ls /

RUN echo "appuser:x:65534:65534:Appuser:/:" > /etc_passwd

FROM scratch
VOLUME /upload

COPY --from=0 /etc_passwd /etc/passwd

WORKDIR /bin
COPY --from=builder /app/app /app/app

USER appuser

EXPOSE 9999

ENTRYPOINT ["/app/app"]