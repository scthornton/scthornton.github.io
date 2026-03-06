---
layout: cheatsheet
title: "Docker Cheatsheet"
description: "Comprehensive Docker Notes"
date: 2025-01-25
categories: [ai-ml, networking, security, programming]
tags: [docker, containers, kubernetes, development]
---

# Docker Comprehensive Cheatsheet

## Table of Contents
1. [Docker Basics](#docker-basics)
2. [Installation and Setup](#installation-and-setup)
3. [Docker Images](#docker-images)
4. [Docker Containers](#docker-containers)
5. [Dockerfile](#dockerfile)
6. [Docker Volumes](#docker-volumes)
7. [Docker Networks](#docker-networks)
8. [Docker Compose](#docker-compose)
9. [Docker Registry](#docker-registry)
10. [Container Management](#container-management)
11. [Docker Build](#docker-build)
12. [Multi-Stage Builds](#multi-stage-builds)
13. [Docker Security](#docker-security)
14. [Docker Swarm](#docker-swarm)
15. [Monitoring and Logging](#monitoring-and-logging)
16. [Best Practices](#best-practices)
17. [Troubleshooting](#troubleshooting)
18. [Docker System](#docker-system)
19. [Advanced Techniques](#advanced-techniques)
20. [Tips and Tricks](#tips-and-tricks)

## Docker Basics

### What is Docker?
Docker is a platform for developing, shipping, and running applications in containers. Think of containers as lightweight, portable boxes that contain everything needed to run an application - code, runtime, system tools, libraries, and settings.

### Key Concepts
- **Image**: A read-only template with instructions for creating a container (like a blueprint)
- **Container**: A runnable instance of an image (like a house built from the blueprint)
- **Dockerfile**: A text file containing instructions to build an image
- **Registry**: A storage and distribution system for Docker images (Docker Hub)
- **Volume**: Persistent data storage for containers
- **Network**: Communication layer between containers

### Architecture
```
┌─────────────────┐     ┌─────────────────┐
│   Docker CLI    │────▶│  Docker Daemon  │
└─────────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌─────────────┐
                        │  Container  │
                        │   Runtime   │
                        └─────────────┘
```

## Installation and Setup

### Install Docker
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (logout/login required)
sudo usermod -aG docker $USER

# macOS
# Download Docker Desktop from docker.com

# Windows
# Download Docker Desktop from docker.com
# Enable WSL 2 backend

# Verify installation
docker --version
docker run hello-world
```

### Docker Configuration
```bash
# Docker daemon configuration
# /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  },
  "insecure-registries": ["myregistry:5000"],
  "registry-mirrors": ["https://mirror.example.com"]
}

# Restart Docker
sudo systemctl restart docker
```

## Docker Images

### Working with Images
```bash
# List images
docker images
docker images -a           # Include intermediate images
docker image ls           # New syntax

# Search images
docker search ubuntu
docker search --limit 5 ubuntu
docker search --filter stars=100 ubuntu

# Pull images
docker pull ubuntu
docker pull ubuntu:20.04
docker pull ubuntu@sha256:abc123...  # By digest

# Push images
docker push username/image:tag
docker push myregistry.com/image:tag

# Remove images
docker rmi image_name
docker rmi image_id
docker rmi $(docker images -q)  # Remove all

# Tag images
docker tag source_image:tag new_image:tag
docker tag ubuntu:latest myubuntu:v1

# Image history
docker history image_name
docker history --no-trunc image_name

# Inspect images
docker inspect image_name
docker inspect image_name | jq '.[0].Config'

# Save/load images
docker save -o ubuntu.tar ubuntu:latest
docker load -i ubuntu.tar

# Export/import (flattened)
docker export container_id > container.tar
docker import container.tar new_image:tag
```

### Image Management
```bash
# Remove unused images
docker image prune
docker image prune -a      # Remove all unused
docker image prune --filter "until=24h"

# List image layers
docker history --no-trunc image_name

# Show image manifest
docker manifest inspect image_name

# Build image from Dockerfile
docker build -t myapp:latest .
docker build -f Dockerfile.prod -t myapp:prod .
docker build --no-cache -t myapp:latest .
```

## Docker Containers

### Container Lifecycle
```bash
# Create container
docker create --name mycontainer ubuntu
docker create -it --name mycontainer ubuntu bash

# Start container
docker start container_name
docker start -ai container_name  # Attach and interactive

# Run container (create and start)
docker run ubuntu
docker run -it ubuntu bash       # Interactive with terminal
docker run -d nginx             # Detached (background)
docker run --name mynginx nginx # Named container
docker run --rm ubuntu echo "Hello"  # Remove after exit

# Stop container
docker stop container_name
docker stop -t 30 container_name  # Custom timeout

# Restart container
docker restart container_name

# Pause/unpause
docker pause container_name
docker unpause container_name

# Kill container (force stop)
docker kill container_name
docker kill -s SIGTERM container_name

# Remove container
docker rm container_name
docker rm -f container_name      # Force remove
docker rm $(docker ps -aq)       # Remove all
```

### Container Inspection
```bash
# List containers
docker ps                        # Running containers
docker ps -a                     # All containers
docker ps -q                     # Only IDs
docker ps --filter "status=exited"
docker ps --format "table {{.Names}}\t{{.Status}}"

# Inspect container
docker inspect container_name
docker inspect -f '{{.State.Running}}' container_name

# Container logs
docker logs container_name
docker logs -f container_name    # Follow logs
docker logs --tail 50 container_name
docker logs --since 2h container_name
docker logs -t container_name    # Timestamps

# Container processes
docker top container_name

# Container stats
docker stats                     # All containers
docker stats container_name
docker stats --no-stream        # One-time snapshot

# Container changes
docker diff container_name
```

### Interacting with Containers
```bash
# Execute commands
docker exec container_name ls
docker exec -it container_name bash
docker exec -u root container_name command
docker exec -w /app container_name pwd

# Attach to container
docker attach container_name
# Detach: Ctrl-P Ctrl-Q

# Copy files
docker cp file.txt container:/path/
docker cp container:/path/file.txt .
docker cp container:/app/ ./backup/

# Port mapping
docker run -p 8080:80 nginx     # Host:Container
docker run -p 127.0.0.1:8080:80 nginx
docker run -P nginx             # Random ports
docker port container_name      # Show mappings

# Environment variables
docker run -e VAR=value ubuntu
docker run -e VAR ubuntu        # Pass from host
docker run --env-file .env ubuntu

# Volume mounting
docker run -v /host/path:/container/path ubuntu
docker run -v volume_name:/data ubuntu
docker run --mount type=bind,source=/host,target=/container ubuntu
```

## Dockerfile

### Basic Dockerfile Structure
```dockerfile
# Dockerfile
# Base image
FROM ubuntu:20.04

# Metadata
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Application description"

# Arguments (build-time)
ARG NODE_VERSION=14

# Environment variables (runtime)
ENV NODE_ENV=production
ENV PORT=3000

# Set working directory
WORKDIR /app

# Copy files
COPY package*.json ./
COPY . .

# Add files (can download from URL)
ADD https://example.com/file.tar.gz /tmp/

# Run commands
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -m -s /bin/bash appuser
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Volume
VOLUME ["/data"]

# Entry point (not overridden by docker run arguments)
ENTRYPOINT ["node"]

# Default command (can be overridden)
CMD ["server.js"]
```

### Dockerfile Best Practices
```dockerfile
# Multi-line arguments
RUN apt-get update \
    && apt-get install -y \
        package1 \
        package2 \
        package3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Combine layers
# Bad
RUN apt-get update
RUN apt-get install -y nodejs

# Good
RUN apt-get update && apt-get install -y nodejs

# Use specific versions
FROM node:14.17.0-alpine

# Leverage build cache
# Copy dependency files first
COPY package*.json ./
RUN npm ci --only=production
# Then copy source code
COPY . .

# Non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

# Use .dockerignore
# .dockerignore file:
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.DS_Store
```

### Advanced Dockerfile Directives
```dockerfile
# Shell form vs Exec form
# Shell form (runs in shell)
RUN apt-get update

# Exec form (preferred)
RUN ["apt-get", "update"]

# ONBUILD - triggers on child images
ONBUILD COPY . /app
ONBUILD RUN npm install

# STOPSIGNAL - set stop signal
STOPSIGNAL SIGTERM

# ARG with default values
ARG VERSION=latest
ARG PORT=3000
ENV PORT=$PORT

# Conditional execution
ARG BUILD_ENV=production
RUN if [ "$BUILD_ENV" = "development" ]; then \
        npm install; \
    else \
        npm ci --only=production; \
    fi
```

## Docker Volumes

### Volume Management
```bash
# Create volume
docker volume create myvolume
docker volume create --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.1.1,rw \
    --opt device=:/data \
    nfsvolume

# List volumes
docker volume ls
docker volume ls -q              # Quiet (IDs only)
docker volume ls --filter dangling=true

# Inspect volume
docker volume inspect myvolume

# Remove volume
docker volume rm myvolume
docker volume prune              # Remove unused
docker volume prune -f           # Force

# Use volumes
docker run -v myvolume:/data ubuntu
docker run --mount source=myvolume,target=/data ubuntu

# Bind mounts
docker run -v /host/path:/container/path ubuntu
docker run --mount type=bind,source=/host/path,target=/container/path ubuntu

# Read-only volumes
docker run -v myvolume:/data:ro ubuntu
docker run --mount source=myvolume,target=/data,readonly ubuntu

# tmpfs mounts (memory)
docker run --tmpfs /tmp ubuntu
docker run --mount type=tmpfs,destination=/tmp,tmpfs-size=100m ubuntu
```

### Volume Backup and Restore
```bash
# Backup volume
docker run --rm \
    -v myvolume:/source:ro \
    -v $(pwd):/backup \
    ubuntu tar czf /backup/backup.tar.gz -C /source .

# Restore volume
docker run --rm \
    -v myvolume:/target \
    -v $(pwd):/backup \
    ubuntu tar xzf /backup/backup.tar.gz -C /target

# Copy between volumes
docker run --rm \
    -v source_volume:/source:ro \
    -v dest_volume:/dest \
    ubuntu cp -av /source/. /dest/
```

## Docker Networks

### Network Management
```bash
# List networks
docker network ls
docker network ls --filter driver=bridge

# Create network
docker network create mynetwork
docker network create --driver bridge mybridge
docker network create --subnet=172.20.0.0/16 custom

# Inspect network
docker network inspect bridge
docker network inspect mynetwork

# Remove network
docker network rm mynetwork
docker network prune            # Remove unused

# Connect/disconnect containers
docker network connect mynetwork container_name
docker network disconnect mynetwork container_name

# Run container with network
docker run --network mynetwork nginx
docker run --network host nginx      # Host network
docker run --network none nginx      # No network

# Custom network with options
docker network create \
    --driver bridge \
    --subnet=172.20.0.0/16 \
    --ip-range=172.20.240.0/20 \
    --gateway=172.20.0.1 \
    --attachable \
    custom_network
```

### Network Types
```bash
# Bridge (default)
docker run --network bridge nginx

# Host (container uses host network)
docker run --network host nginx

# None (no networking)
docker run --network none nginx

# Overlay (Swarm multi-host)
docker network create -d overlay myoverlay

# Macvlan (assign MAC address)
docker network create -d macvlan \
    --subnet=192.168.1.0/24 \
    --gateway=192.168.1.1 \
    -o parent=eth0 \
    macvlan_net
```

### Container Communication
```bash
# Link containers (deprecated)
docker run --link db:database webapp

# User-defined network (preferred)
docker network create app_network
docker run --name db --network app_network mysql
docker run --name web --network app_network nginx

# DNS in user-defined networks
# Containers can reach each other by name
docker exec web ping db

# Expose and publish ports
docker run --expose 8080 nginx  # Internal only
docker run -p 8080:80 nginx     # Publish to host
docker run -P nginx             # Publish all exposed
```

## Docker Compose

### docker-compose.yml Structure
```yaml
version: '3.8'

services:
  web:
    build: 
      context: .
      dockerfile: Dockerfile
      args:
        - BUILD_ENV=production
    image: myapp:latest
    container_name: myapp_web
    ports:
      - "8080:80"
    environment:
      - NODE_ENV=production
      - DB_HOST=db
    env_file:
      - .env
    volumes:
      - ./app:/app
      - node_modules:/app/node_modules
    networks:
      - app_network
    depends_on:
      - db
      - redis
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  db:
    image: postgres:13
    container_name: myapp_db
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - db_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - app_network
    restart: always

  redis:
    image: redis:6-alpine
    container_name: myapp_redis
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    networks:
      - app_network
    restart: always

volumes:
  db_data:
    driver: local
  redis_data:
    driver: local
  node_modules:
    driver: local

networks:
  app_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### Docker Compose Commands
```bash
# Start services
docker-compose up
docker-compose up -d            # Detached
docker-compose up --build       # Rebuild images
docker-compose up --scale web=3 # Scale service

# Stop services
docker-compose down
docker-compose down -v          # Remove volumes
docker-compose down --rmi all   # Remove images

# Service management
docker-compose start
docker-compose stop
docker-compose restart
docker-compose pause
docker-compose unpause

# View status
docker-compose ps
docker-compose top
docker-compose logs
docker-compose logs -f web      # Follow specific service

# Execute commands
docker-compose exec web bash
docker-compose exec -T db mysqldump > backup.sql
docker-compose run --rm web npm test

# Build images
docker-compose build
docker-compose build --no-cache
docker-compose build --parallel

# Pull images
docker-compose pull
docker-compose pull --ignore-pull-failures

# Configuration
docker-compose config           # Validate and view
docker-compose --env-file .env.prod up
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

### Advanced Compose Features
```yaml
# Override files
# docker-compose.override.yml (automatically loaded)
version: '3.8'
services:
  web:
    build:
      context: .
      target: development
    volumes:
      - .:/app
    environment:
      - DEBUG=true

# Extensions (reduce duplication)
x-common-variables: &common-variables
  REDIS_HOST: redis
  REDIS_PORT: 6379

services:
  web:
    environment:
      <<: *common-variables
      NODE_ENV: production

  worker:
    environment:
      <<: *common-variables
      WORKER_TYPE: background

# Profiles (Compose 1.28+)
services:
  web:
    profiles: ["frontend"]
  
  debug:
    profiles: ["debug"]

# Run with profile
# docker-compose --profile frontend up
```

## Docker Registry

### Docker Hub
```bash
# Login/logout
docker login
docker login -u username
docker logout

# Push to Docker Hub
docker tag myimage:latest username/myimage:latest
docker push username/myimage:latest

# Pull from Docker Hub
docker pull username/myimage:latest

# Search Docker Hub
docker search nginx
docker search --filter is-official=true nginx
docker search --filter stars=100 nginx
```

### Private Registry
```bash
# Run local registry
docker run -d -p 5000:5000 --name registry registry:2

# With authentication
docker run -d \
    -p 5000:5000 \
    --name registry \
    -v /path/to/auth:/auth \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
    registry:2

# Push to private registry
docker tag myimage localhost:5000/myimage
docker push localhost:5000/myimage

# Pull from private registry
docker pull localhost:5000/myimage

# List images in registry
curl -X GET http://localhost:5000/v2/_catalog
curl -X GET http://localhost:5000/v2/myimage/tags/list

# Delete image from registry
curl -X DELETE http://localhost:5000/v2/myimage/manifests/sha256:...
```

### Registry Configuration
```yaml
# config.yml for registry
version: 0.1
log:
  level: info
  formatter: json
storage:
  filesystem:
    rootdirectory: /var/lib/registry
  delete:
    enabled: true
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
auth:
  htpasswd:
    realm: basic-realm
    path: /auth/htpasswd
```

## Container Management

### Resource Limits
```bash
# CPU limits
docker run --cpus="1.5" nginx   # 1.5 CPUs
docker run --cpu-shares=512 nginx
docker run --cpuset-cpus="0,1" nginx  # Specific CPUs

# Memory limits
docker run -m 512m nginx         # 512 MB
docker run --memory=1g nginx
docker run --memory=1g --memory-swap=2g nginx
docker run --memory-reservation=500m nginx

# Device limits
docker run --device-read-bps /dev/sda:1mb nginx
docker run --device-write-iops /dev/sda:1000 nginx

# Update running container
docker update --cpus="2" container_name
docker update --memory="1g" container_name
```

### Container Security
```bash
# Run as specific user
docker run -u 1000:1000 nginx
docker run --user $(id -u):$(id -g) nginx

# Read-only root filesystem
docker run --read-only nginx

# Drop capabilities
docker run --cap-drop=ALL nginx
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx

# Security options
docker run --security-opt no-new-privileges nginx
docker run --security-opt apparmor=docker-default nginx
docker run --security-opt seccomp=default.json nginx

# Privileged mode (use carefully!)
docker run --privileged nginx

# PID namespace
docker run --pid=host nginx
docker run --pid=container:name nginx
```

### Container Monitoring
```bash
# Real-time stats
docker stats
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Events
docker events
docker events --since '2023-01-01'
docker events --filter container=name
docker events --filter event=start

# System information
docker system df                 # Disk usage
docker system info              # System info
docker system prune             # Clean up
docker system prune -a          # Remove all unused

# Container details
docker inspect container_name
docker inspect -f '{{.State.Health.Status}}' container_name
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name
```

## Docker Build

### Build Context
```bash
# Build from current directory
docker build -t myapp .

# Build from specific directory
docker build -t myapp /path/to/context

# Build from Git repository
docker build -t myapp https://github.com/user/repo.git
docker build -t myapp https://github.com/user/repo.git#branch
docker build -t myapp https://github.com/user/repo.git#:folder

# Build from stdin
docker build -t myapp - < Dockerfile
cat Dockerfile | docker build -t myapp -
docker build -t myapp -f- . < Dockerfile

# Build arguments
docker build --build-arg VERSION=1.0 -t myapp .
docker build --build-arg HTTP_PROXY=http://proxy:8080 -t myapp .

# Build options
docker build --no-cache -t myapp .
docker build --pull -t myapp .            # Always pull base image
docker build --compress -t myapp .        # Compress context
docker build --squash -t myapp .          # Squash layers
```

### BuildKit
```bash
# Enable BuildKit
export DOCKER_BUILDKIT=1

# Build with BuildKit
docker build -t myapp .

# Multi-platform builds
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t myapp .

# Cache mounting
# In Dockerfile:
# syntax=docker/dockerfile:1
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y gcc

# Secret mounting
docker build --secret id=mysecret,src=secret.txt .
# In Dockerfile:
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret

# SSH mounting
docker build --ssh default .
# In Dockerfile:
RUN --mount=type=ssh git clone git@github.com:user/repo.git
```

## Multi-Stage Builds

### Multi-Stage Dockerfile
```dockerfile
# Build stage
FROM node:14 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Test stage
FROM builder AS tester
RUN npm test

# Production stage
FROM node:14-alpine
WORKDIR /app
# Copy from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
EXPOSE 3000
CMD ["node", "dist/server.js"]

# Development stage
FROM builder AS development
ENV NODE_ENV=development
CMD ["npm", "run", "dev"]
```

### Building Specific Stages
```bash
# Build specific target
docker build --target builder -t myapp:builder .
docker build --target development -t myapp:dev .
docker build --target production -t myapp:prod .

# Copy from specific stage
docker build --target builder -t temp .
docker create --name temp temp
docker cp temp:/app/dist ./dist
docker rm temp
```

## Docker Security

### Security Scanning
```bash
# Scan images for vulnerabilities
docker scan myimage
docker scan --severity high myimage
docker scan --file Dockerfile myimage

# Use Trivy for scanning
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    aquasec/trivy image myimage:latest

# Content trust
export DOCKER_CONTENT_TRUST=1
docker pull signed-image
docker push signed-image

# Sign images
docker trust sign myimage:latest
docker trust inspect --pretty myimage:latest
```

### Security Best Practices
```dockerfile
# Use minimal base images
FROM alpine:3.14
# Or distroless images
FROM gcr.io/distroless/nodejs14

# Don't run as root
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

# Avoid sudo
# Bad
RUN apt-get update && apt-get install -y sudo

# Use COPY instead of ADD
COPY app.tar.gz .
RUN tar -xzf app.tar.gz

# Verify downloads
RUN curl -fsSL https://example.com/file.tar.gz -o file.tar.gz \
    && echo "sha256sum file.tar.gz" | sha256sum -c - \
    && tar -xzf file.tar.gz

# Use secrets properly
# Bad
ENV API_KEY=secret123

# Good - use build secrets
RUN --mount=type=secret,id=api_key \
    API_KEY=$(cat /run/secrets/api_key) && \
    # Use API_KEY here
```

## Docker Swarm

### Swarm Management
```bash
# Initialize swarm
docker swarm init
docker swarm init --advertise-addr 192.168.1.100

# Join swarm
docker swarm join --token SWMTKN-1-xxx 192.168.1.100:2377

# Get join tokens
docker swarm join-token worker
docker swarm join-token manager

# Leave swarm
docker swarm leave
docker swarm leave --force      # On manager

# Update swarm
docker swarm update --autolock=true
```

### Service Management
```bash
# Create service
docker service create --name web nginx
docker service create --replicas 3 --name web nginx
docker service create \
    --name web \
    --publish 80:80 \
    --mount type=volume,source=data,target=/data \
    --env NODE_ENV=production \
    nginx

# List services
docker service ls
docker service ps web           # Tasks for service

# Update service
docker service update --replicas 5 web
docker service update --image nginx:latest web
docker service update --limit-cpu 0.5 --limit-memory 128M web

# Scale service
docker service scale web=10
docker service scale web=10 api=5

# Remove service
docker service rm web

# Rolling updates
docker service update \
    --update-parallelism 2 \
    --update-delay 10s \
    --update-failure-action rollback \
    web

# Service logs
docker service logs web
docker service logs -f web
```

### Stack Deployment
```yaml
# docker-stack.yml
version: '3.8'

services:
  web:
    image: nginx
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
      placement:
        constraints:
          - node.role == worker
          - node.labels.type == web

  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    secrets:
      - db_password
    deploy:
      placement:
        constraints:
          - node.labels.type == database

secrets:
  db_password:
    external: true
```

```bash
# Deploy stack
docker stack deploy -c docker-stack.yml myapp

# List stacks
docker stack ls
docker stack ps myapp
docker stack services myapp

# Remove stack
docker stack rm myapp
```

## Monitoring and Logging

### Logging Drivers
```bash
# Configure logging
docker run --log-driver json-file --log-opt max-size=10m nginx
docker run --log-driver syslog --log-opt syslog-address=tcp://192.168.1.100:514 nginx

# Available drivers
# json-file (default)
# syslog
# journald
# fluentd
# awslogs
# splunk
# gcplogs

# View logs
docker logs container_name
docker logs -f container_name    # Follow
docker logs --tail 100 container_name
docker logs --since 2023-01-01 container_name
docker logs -t container_name    # Timestamps
```

### Monitoring Tools
```bash
# Prometheus + Grafana stack
docker run -d \
    -p 9090:9090 \
    -v prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus

docker run -d \
    -p 3000:3000 \
    grafana/grafana

# cAdvisor for container metrics
docker run -d \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --publish=8080:8080 \
    google/cadvisor:latest

# Portainer for management
docker run -d \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce
```

## Best Practices

### Image Optimization
```dockerfile
# Use specific tags
FROM node:14.17.0-alpine

# Minimize layers
RUN apt-get update \
    && apt-get install -y \
        package1 \
        package2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Order matters (cache efficiency)
# Less frequently changing items first
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Multi-stage builds
FROM node:14 AS builder
WORKDIR /app
COPY . .
RUN npm ci && npm run build

FROM node:14-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/server.js"]

# Use .dockerignore
# .dockerignore:
.git/
.gitignore
README.md
.env
node_modules/
npm-debug.log
.DS_Store
.vscode/
coverage/
.nyc_output/
```

### Container Best Practices
```bash
# One process per container
# Use init system if needed
docker run --init myapp

# Handle signals properly
# In application:
process.on('SIGTERM', gracefulShutdown);

# Use health checks
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/health || exit 1

# Log to stdout/stderr
# Configure app to log to console, not files

# Store data in volumes
docker run -v data:/app/data myapp

# Use secrets for sensitive data
docker secret create db_password password.txt
docker service create --secret db_password myapp

# Set resource limits
docker run --memory=512m --cpus="1.0" myapp
```

## Troubleshooting

### Common Issues
```bash
# Container won't start
docker logs container_name
docker inspect container_name
docker events --filter container=container_name

# Permission denied
# Check user in Dockerfile
# Check volume permissions
docker exec container_name ls -la /path

# Cannot connect to container
docker port container_name
docker inspect container_name | grep IPAddress
docker exec container_name netstat -tlnp

# Disk space issues
docker system df
docker system prune -a
docker volume prune
docker image prune -a

# Build failures
docker build --no-cache .
docker build --progress=plain .  # Verbose output
DOCKER_BUILDKIT=0 docker build . # Disable BuildKit

# Network issues
docker network ls
docker network inspect bridge
docker exec container_name ping google.com
```

### Debugging Containers
```bash
# Debug running container
docker exec -it container_name /bin/bash
docker exec -it container_name /bin/sh  # For Alpine

# Debug stopped container
docker run -it --entrypoint /bin/bash image_name
docker run -it --entrypoint /bin/sh image_name

# Override CMD
docker run -it image_name /bin/bash

# Debug with more tools
docker run -it --rm \
    --pid container:target_container \
    --net container:target_container \
    --cap-add SYS_PTRACE \
    nicolaka/netshoot

# Copy files for inspection
docker cp container_name:/app/logs ./logs

# Commit container for debugging
docker commit container_name debug_image
docker run -it debug_image /bin/bash
```

## Docker System

### System Commands
```bash
# System info
docker system info
docker version
docker info

# Disk usage
docker system df
docker system df -v             # Verbose

# Clean up
docker system prune             # Remove unused
docker system prune -a          # Remove all unused
docker system prune --volumes   # Include volumes

# Events
docker system events
docker system events --since '1h'
docker system events --filter type=container
docker system events --format '{{json .}}'
```

### Docker Context
```bash
# List contexts
docker context ls

# Create context
docker context create remote --docker "host=ssh://user@remote"
docker context create aci --docker "host=aci"

# Use context
docker context use remote
docker --context remote ps

# Inspect context
docker context inspect default

# Remove context
docker context rm remote
```

## Advanced Techniques

### Docker in Docker (DinD)
```bash
# Run Docker inside Docker
docker run --privileged -d docker:dind

# Connect to DinD
docker run --rm \
    --link dind:docker \
    -e DOCKER_HOST=tcp://docker:2375 \
    docker:latest version

# Mount Docker socket (preferred)
docker run -v /var/run/docker.sock:/var/run/docker.sock \
    docker:latest docker ps
```

### Custom Networks
```bash
# Create custom bridge
docker network create \
    --driver bridge \
    --subnet=172.20.0.0/16 \
    --ip-range=172.20.240.0/20 \
    --gateway=172.20.0.1 \
    --opt com.docker.network.bridge.name=docker1 \
    custom_bridge

# Create overlay network (Swarm)
docker network create \
    --driver overlay \
    --subnet=10.0.0.0/16 \
    --opt encrypted \
    my_overlay

# Create macvlan
docker network create \
    --driver macvlan \
    --subnet=192.168.1.0/24 \
    --gateway=192.168.1.1 \
    --opt parent=eth0 \
    my_macvlan
```

### Advanced Volume Options
```bash
# NFS volume
docker volume create \
    --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.1.100,rw \
    --opt device=:/path/to/dir \
    nfs_volume

# CIFS/SMB volume
docker volume create \
    --driver local \
    --opt type=cifs \
    --opt o=username=user,password=pass,domain=domain \
    --opt device=//server/share \
    cifs_volume

# tmpfs volume
docker run --tmpfs /app/tmp:rw,size=100m,mode=1777 nginx

# Device mapping
docker run --device /dev/sda:/dev/xvda:rwm ubuntu
```
