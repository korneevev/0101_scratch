# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /app
COPY . .

RUN go mod download
RUN go build -o scratch cmd/main.go

RUN echo "appuser:x:65534:65534:Appuser:/:" > /etc_passwd

FROM scratch
VOLUME /upload

COPY --from=0 /etc_passwd /etc/passwd

WORKDIR /
COPY --from=build /app/scratch /scratch

EXPOSE 9999

USER appuser
CMD ["./scratch"]