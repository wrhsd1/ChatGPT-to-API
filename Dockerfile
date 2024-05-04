# Use the official Golang image as the builder
FROM golang:1.20.3-alpine as builder

RUN apt-get update && apt-get install -y git

WORKDIR /go/src/app
COPY . .

# Clone the specific repository and build the application.
RUN git clone https://github.com/xqdoo00o/ChatGPT-to-API /go/src/app \
    && cd /go/src/app \
    && go build -o freechatgpt

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/
FROM debian:buster-slim

# Copy the binary to the production image from the builder stage.
COPY --from=builder /go/src/app/freechatgpt /freechatgpt

# Run the freechatgpt command by default when the container starts.
ENTRYPOINT ["/freechatgpt"]

# Document that the service listens on port 8080.
EXPOSE 8080
