FROM ubuntu:latest

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install git and clean up in single layer
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set git as entrypoint
ENTRYPOINT ["git"]

# Set working directory
WORKDIR /git

# Add labels for metadata
LABEL maintainer="Md Toriqul Islam <toriqul.int@gmail.com>" \
      description="Ubuntu with Git integration" \
      version="1.0"