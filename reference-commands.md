# Docker Ubuntu Git Integration Command Reference Guide
### Project content table
- [Section 1: Core Project Workflow](#section-1-core-project-workflow)
- [Section 2: Advanced Operations](#section-2-advanced-operations)
- [Section 3: Production Guide](#section-3-production-guide)

> **Author**: [Md Toriqul Islam](https://linkedin.com/in/thetoriqul)  
> **Description**: Comprehensive command reference for Docker Ubuntu Git integration  
> **Learning Focus**: Docker container management, Git integration, and production workflows  
> **Note**: Execute commands sequentially to ensure proper environment setup

## Section 1: Core Project Workflow

### Step 1: Base Container Setup
```bash
# Create Ubuntu container with interactive bash session
docker run -it --name image-dev ubuntu:latest /bin/bash

# Verification command - check container status
docker ps -a | grep image-dev

# Alternative creation with additional options
docker run -it \
    --name image-dev \
    --hostname git-dev \
    --memory="512m" \
    --cpus="1.0" \
    ubuntu:latest /bin/bash
```

### Step 2: Git Installation and Setup
```bash
# Update package repository
apt-get update

# Install Git with all dependencies
apt-get install -y git

# Verify Git installation
git --version

# Configure Git globally (optional)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verification command - check Git configuration
git config --list
```

### Step 3: Image Creation Process
```bash
# Exit container
exit

# Create image with basic commit
docker container commit -a "@poridhi" -m "Added git" image-dev ubuntu-git

# Create image with additional metadata
docker container commit \
    --author "@poridhi" \
    --message "Added git with custom configurations" \
    --change 'ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
    --change 'WORKDIR /git' \
    image-dev ubuntu-git

# Verification command
docker images --filter "reference=ubuntu-git"
```

### Step 4: Entrypoint Configuration
```bash
# Create container with Git entrypoint
docker container run --name cmd-git --entrypoint git ubuntu-git

# Commit container with entrypoint
docker container commit -m "Set CMD git" -a "@poridhi" cmd-git ubuntu-git

# Verification command
docker inspect ubuntu-git --format='{{.Config.Entrypoint}}'
```

### Step 5: Container Cleanup
```bash
# Remove specific containers
docker container rm -vf image-dev
docker container rm -vf cmd-git

# Remove all stopped containers
docker container prune -f

# Cleanup unused volumes
docker volume prune -f

# Verification commands
docker ps -a
docker volume ls
```

## Section 2: Advanced Operations

### Git Container Operations
```bash
# Run Git with version check
docker run --rm ubuntu-git version

# Run Git status in current directory
docker run --rm -v $(pwd):/workspace ubuntu-git status

# Initialize new Git repository
docker run --rm -v $(pwd):/git ubuntu-git init

# Configure Git in container
docker run --rm -v $(pwd):/git ubuntu-git config --global --add safe.directory /git

# Run Git with specific user configuration
docker run --rm \
    -v $(pwd):/git \
    -e GIT_AUTHOR_NAME="Your Name" \
    -e GIT_AUTHOR_EMAIL="your.email@example.com" \
    ubuntu-git commit -m "Commit message"
```

### Container Resource Management
```bash
# Run with resource constraints
docker run --rm \
    --memory="1g" \
    --memory-reservation="750m" \
    --cpus="2.0" \
    --pids-limit=100 \
    ubuntu-git version

# Run with ulimits
docker run --rm \
    --ulimit nofile=1024:2048 \
    --ulimit nproc=100 \
    ubuntu-git version

# Run with specific user
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v $(pwd):/git \
    ubuntu-git status
```

### Network Configuration
```bash
# Run with custom network
docker network create git-net
docker run --rm \
    --network git-net \
    --network-alias git-server \
    ubuntu-git version

# Run with host network
docker run --rm \
    --network host \
    ubuntu-git version
```

## Section 3: Production Guide

### Production Deployment
```bash
# Run in detached mode with restart policy
docker run -d \
    --name git-prod \
    --restart unless-stopped \
    --health-cmd "git --version || exit 1" \
    --health-interval=30s \
    --log-driver json-file \
    --log-opt max-size=10m \
    ubuntu-git version

# Run with specific logging
docker run -d \
    --name git-prod \
    --log-driver json-file \
    --log-opt max-size=10m \
    --log-opt max-file=3 \
    ubuntu-git version
```

### Monitoring and Maintenance
```bash
# Check container health
docker inspect --format='{{.State.Health.Status}}' git-prod

# View container logs
docker logs --tail=100 -f git-prod

# Monitor resource usage
docker stats git-prod

# Export container
docker export git-prod > git-prod.tar

# Save image with layers
docker save ubuntu-git > ubuntu-git.tar
```

### Security Configuration
```bash
# Run with security options
docker run --rm \
    --security-opt no-new-privileges \
    --security-opt apparmor=docker-default \
    --cap-drop ALL \
    --cap-add GIT_OPERATIONS \
    ubuntu-git version

# Run with read-only filesystem
docker run --rm \
    --read-only \
    --tmpfs /tmp \
    ubuntu-git version
```

## Learning Notes

1. Container commits create immutable images
2. Entrypoint configuration enables command simplification
3. Volume mounting provides data persistence
4. Resource constraints ensure stable operation
5. Security configurations protect production environments

---

> 💡 **Best Practice**: Always use resource constraints in production

> ⚠️ **Warning**: Monitor container logs for troubleshooting

> 📝 **Note**: Regularly update base images for security patches