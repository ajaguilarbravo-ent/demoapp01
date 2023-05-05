FROM golang:1.20.3 AS build-stage

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY static .
COPY *.go .

RUN CGO_ENABLED=0 GOOS=linux go build -o app01

FROM alpine:3.13 AS build-release-stage

RUN apk add --no-cache ca-certificates bash

COPY --from=build-stage /app/static /app/static
COPY --from=build-stage /app/app01 /app/app01

WORKDIR /app

EXPOSE 8080

CMD ["/app01"]

