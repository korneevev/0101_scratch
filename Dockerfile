# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/scratch.bin cmd/main.go

RUN echo "appuser:x:65534:65534:Appuser:/:" > /etc_passwd

FROM scratch
VOLUME /upload

COPY --from=build /etc_passwd /etc/passwd
COPY --from=build /go/bin/scratch.bin /scratch


EXPOSE 9999

USER appuser
CMD ["./scratch"]