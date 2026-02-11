# syntax=docker/dockerfile:1
FROM golang:1.22 AS build
WORKDIR /src

COPY app/go.mod app/go.sum ./app/
WORKDIR /src/app
RUN go mod download

COPY app/ /src/app/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/rpi-edge-agent ./cmd/agent

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=build /out/rpi-edge-agent /rpi-edge-agent
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/rpi-edge-agent"]
