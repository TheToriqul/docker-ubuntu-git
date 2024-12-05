.PHONY: build run clean test help

# Variables
IMAGE_NAME := ubuntu-git
CONTAINER_NAME := git-container

# Default target
help:
	@echo "Available commands:"
	@echo "  make build    - Build the Docker image"
	@echo "  make run      - Run the container"
	@echo "  make clean    - Remove container and image"
	@echo "  make test     - Test Git installation"
	@echo "  make help     - Show this help message"

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run the container
run:
	docker run --rm -v $(PWD):/git $(IMAGE_NAME) version

# Clean up
clean:
	docker container rm -f $(CONTAINER_NAME) 2>/dev/null || true
	docker image rm -f $(IMAGE_NAME) 2>/dev/null || true

# Test Git installation
test:
	docker run --rm $(IMAGE_NAME) --version