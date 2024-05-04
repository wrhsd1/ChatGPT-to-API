# Use the official Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
FROM golang:1.18 as builder

# Install git.
RUN apt-get update && apt-get install -y git

# Clone the specific repository into an empty directory.
WORKDIR /go/src/app
RUN git clone https://github.com/xqdoo00o/ChatGPT-to-API . \
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
