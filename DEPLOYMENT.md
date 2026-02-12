# Flutter Web Docker Deployment Guide

This guide provides step-by-step instructions for building and deploying the Flutter web application using Docker.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.10.3 or higher)
- **Docker** (20.10 or higher)
- **Docker Compose** (2.0 or higher)

Verify installations:

```bash
flutter --version
docker --version
docker-compose --version
```

## Project Structure

```
frontend/
├── Dockerfile              # Multi-stage Docker configuration
├── docker-compose.yml       # Docker Compose orchestration
├── .dockerignore          # Files to exclude from Docker build
├── .env.example           # Environment variables template
├── docker/
│   └── nginx.conf         # Nginx configuration
├── scripts/
│   ├── build.sh          # Flutter build script
│   └── deploy.sh         # Docker deployment script
└── build/
    └── web/              # Flutter web build output
```

## Environment Configuration

1. Copy the example environment file:

```bash
cp .env.example .env
```

1. Edit the `.env` file with your configuration:

```bash
# Application Environment
NODE_ENV=production
APP_ENV=production

# Frontend Port Configuration
FRONTEND_PORT=8080

# API Configuration
API_BASE_URL=http://localhost:3000
API_TIMEOUT=30000

# Feature Flags
ENABLE_ANALYTICS=true
ENABLE_DEBUG_MODE=false

# Logging Configuration
LOG_LEVEL=info
```

## Deployment Methods

### Method 1: Using the Deployment Script (Recommended)

The easiest way to deploy is using the provided deployment script:

```bash
# Make the script executable
chmod +x scripts/deploy.sh

# Run the deployment script
./scripts/deploy.sh
```

#### Custom Deployment Options

```bash
# Custom image name and tag
./scripts/deploy.sh --image-name my-frontend --tag v1.0.0

# Custom container name
./scripts/deploy.sh --container-name my-app

# Deploy to a registry
./scripts/deploy.sh --registry my-registry.com --tag v1.0.0

# View all options
./scripts/deploy.sh --help
```

### Method 2: Manual Step-by-Step Deployment

#### Step 1: Build Flutter Web App

```bash
# Using the build script
chmod +x scripts/build.sh
./scripts/build.sh

# Or using Flutter directly
flutter build web --release
```

This creates the production build in the `build/web` directory.

#### Step 2: Build Docker Image

```bash
# Build with default name
docker build -t frontend-app:latest .

# Build with custom name and tag
docker build -t my-frontend:v1.0.0 .
```

#### Step 3: Run Container with Docker Compose

```bash
# Start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

#### Step 4: Verify Deployment

```bash
# Check container status
docker-compose ps

# Check container health
docker inspect --format='{{.State.Health.Status}}' frontend-app

# View application logs
docker logs -f frontend-app

# Test the application
curl http://localhost:8080/health
```

### Method 3: Manual Docker Commands (Without Docker Compose)

```bash
# Build the image
docker build -t frontend-app:latest .

# Run the container
docker run -d \
  --name frontend-app \
  -p 8080:80 \
  -e NODE_ENV=production \
  -e API_BASE_URL=http://localhost:3000 \
  --restart unless-stopped \
  frontend-app:latest

# View logs
docker logs -f frontend-app

# Stop and remove container
docker stop frontend-app
docker rm frontend-app
```

## Container Management

### View Container Status

```bash
# List running containers
docker ps

# View detailed container information
docker inspect frontend-app

# View container resource usage
docker stats frontend-app
```

### View Logs

```bash
# Follow logs in real-time
docker logs -f frontend-app

# View last 100 lines
docker logs --tail 100 frontend-app

# View logs with timestamps
docker logs -t frontend-app
```

### Stop and Start

```bash
# Stop the container
docker-compose stop

# Start the container
docker-compose start

# Restart the container
docker-compose restart

# Stop and remove containers
docker-compose down
```

### Update and Redeploy

```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose up -d --build

# Or using the deployment script
./scripts/deploy.sh
```

## Health Check

The container includes a built-in health check:

```bash
# Check health status
docker inspect --format='{{.State.Health.Status}}' frontend-app

# Test health endpoint
curl http://localhost:8080/health
```

Expected response:

```
healthy
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs for errors
docker logs frontend-app

# Verify port is not already in use
netstat -tlnp | grep 8080

# Check Docker daemon is running
docker ps
```

### Build Fails

```bash
# Clean Docker build cache
docker system prune -a

# Clean Flutter build
flutter clean

# Rebuild
docker build --no-cache -t frontend-app:latest .
```

### Health Check Fails

```bash
# Check nginx is running
docker exec frontend-app ps aux | grep nginx

# Test nginx configuration
docker exec frontend-app nginx -t

# Check file permissions
docker exec frontend-app ls -la /usr/share/nginx/html
```

### Port Conflicts

Edit the `.env` file to change the port:

```bash
FRONTEND_PORT=9090
```

Then restart:

```bash
docker-compose down
docker-compose up -d
```

## Production Considerations

### Resource Limits

The docker-compose.yml includes resource limits:

```yaml
deploy:
  resources:
    limits:
      cpus: '1.0'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 128M
```

Adjust these based on your needs.

### Logging

Logs are configured to rotate:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### Security

- Container runs as non-root user (nginx)
- Security headers are configured in nginx.conf
- Environment variables for sensitive data

### Performance Optimization

- Gzip compression enabled
- Static assets cached for 1 year
- Client-side routing supported

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.5'
      
      - name: Build Flutter Web
        run: flutter build web --release
      
      - name: Build Docker Image
        run: docker build -t frontend-app:${{ github.sha }} .
      
      - name: Deploy
        run: |
          docker-compose up -d
```

## Additional Resources

- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Configuration](https://nginx.org/en/docs/)

## Support

For issues or questions:

1. Check the logs: `docker logs frontend-app`
2. Verify health status: `curl http://localhost:8080/health`
3. Review the troubleshooting section above
