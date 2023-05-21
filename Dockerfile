# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /build
COPY . .

RUN go mod download
RUN go build -o /app/app cmd/main.go

RUN echo "appuser:x:65534:65534:Appuser:/:" > /etc_passwd

FROM scratch
VOLUME /upload

COPY --from=0 /etc_passwd /etc/passwd

WORKDIR /app
COPY --from=builder /app/app /app/app

USER appuser

EXPOSE 9999

ENTRYPOINT ["/app/app"]