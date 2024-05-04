# Use the official Golang image as the builder
FROM golang:1.20.3-alpine as builder

# Enable CGO to use C libraries (set to 0 to disable it)
ENV CGO_ENABLED=0

# Set the working directory inside the builder stage
WORKDIR /app

# Clone the repository
RUN apk add --no-cache git && \
    git clone https://github.com/xqdoo00o/ChatGPT-to-API .

# Build the Go application and output the binary to /app/freechatgpt
RUN go build -o /app/freechatgpt .

# Use a scratch image as the final distroless image
FROM scratch

# Set the working directory in the final image
WORKDIR /app

# Copy the built Go binary from the builder stage
COPY --from=builder /app/freechatgpt /app/freechatgpt

# Expose the port where the application is running
EXPOSE 8080

# Start the application
CMD [ "./freechatgpt" ]
