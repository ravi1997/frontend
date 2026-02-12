# Quick Start Guide - Flutter Web Docker Deployment

## Prerequisites Check

```bash
# Verify Flutter is installed
flutter --version

# Verify Docker is installed
docker --version

# Verify Docker Compose is installed
docker-compose --version
```

## Step-by-Step Deployment

### Step 1: Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit the .env file with your configuration (optional)
nano .env
```

### Step 2: Build Flutter Web App (Release Mode)

```bash
# Option A: Using the build script (recommended)
./scripts/build.sh

# Option B: Using Flutter directly
flutter build web --release
```

**Expected Output:**

```
✓ Built build/web
Build size: 15M
```

### Step 3: Build Docker Image

```bash
# Build the Docker image
docker build -t frontend-app:latest .
```

**Expected Output:**

```
[+] Building 120.5s (12/12) FINISHED
=> => naming to docker.io/library/frontend-app:latest
```

### Step 4: Run Container with Docker Compose

```bash
# Start the container
docker-compose up -d
```

**Expected Output:**

```
[+] Running 2/2
✔ Network frontend-network      Created
✔ Container frontend-app        Started
```

### Step 5: Verify Deployment

```bash
# Check container status
docker-compose ps

# Check container health
docker inspect --format='{{.State.Health.Status}}' frontend-app

# Test the application
curl http://localhost:8080/health
```

**Expected Output:**

```
healthy
```

### Step 6: Access the Application

Open your browser and navigate to:

```
http://localhost:8080
```

## One-Command Deployment (Recommended)

If you want to automate the entire process, use the deployment script:

```bash
# Run the deployment script
./scripts/deploy.sh
```

This script will:

1. Build the Flutter web app in release mode
2. Build the Docker image
3. Stop any existing container
4. Start the new container
5. Wait for the health check to pass
6. Display deployment information

## Useful Commands

### View Logs

```bash
# Follow logs in real-time
docker logs -f frontend-app

# View last 100 lines
docker logs --tail 100 frontend-app
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

### Container Management

```bash
# View container stats
docker stats frontend-app

# View detailed container information
docker inspect frontend-app

# Execute command in container
docker exec -it frontend-app sh
```

## Troubleshooting

### Container won't start

```bash
# Check logs
docker logs frontend-app

# Check port availability
netstat -tlnp | grep 8080
```

### Build fails

```bash
# Clean Docker build cache
docker system prune -a

# Clean Flutter build
flutter clean

# Rebuild
docker build --no-cache -t frontend-app:latest .
```

### Port conflict

Edit `.env` file:

```bash
FRONTEND_PORT=9090
```

Then restart:

```bash
docker-compose down
docker-compose up -d
```

## Environment Variables

Available environment variables (configure in `.env`):

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | production | Node environment |
| `APP_ENV` | production | Application environment |
| `FRONTEND_PORT` | 8080 | Port to expose the application |
| `API_BASE_URL` | <http://localhost:3000> | Backend API URL |
| `API_TIMEOUT` | 30000 | API timeout in milliseconds |
| `ENABLE_ANALYTICS` | true | Enable analytics |
| `ENABLE_DEBUG_MODE` | false | Enable debug mode |
| `LOG_LEVEL` | info | Logging level |

## Health Check

The container includes a health check endpoint:

```bash
curl http://localhost:8080/health
```

Expected response: `healthy`

## Production Deployment

For production deployment:

1. Update environment variables in `.env`
2. Build and push to a registry:

   ```bash
   docker tag frontend-app:latest my-registry.com/frontend-app:v1.0.0
   docker push my-registry.com/frontend-app:v1.0.0
   ```

3. Deploy to your production server

## Next Steps

- Read the full [DEPLOYMENT.md](DEPLOYMENT.md) for detailed information
- Review [docker/nginx.conf](docker/nginx.conf) for nginx configuration
- Check [Dockerfile](Dockerfile) for build configuration
- Customize [docker-compose.yml](docker-compose.yml) for your needs
