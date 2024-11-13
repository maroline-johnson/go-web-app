# Stage 1: Build
FROM golang:1.22.5 AS builder

WORKDIR /app

# Install dependencies
COPY go.mod .
RUN go mod download

# Copy app files and build
COPY . .
RUN go build -o main .

# Stage 2: Final with distroless image
FROM gcr.io/distroless/base

# Copy binary and static files
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]