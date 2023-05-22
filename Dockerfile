# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -o /go/src/app/scratch cmd/main.go

ENV USER=appuser
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR /
RUN mkdir /upload && chown appuser: /upload


FROM scratch
VOLUME /upload

WORKDIR /
COPY --from=build /go/src/app/scratch .

USER appuser:appuser
EXPOSE 9999
ENTRYPOINT ["./scratch"]