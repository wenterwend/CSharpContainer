# .NET 8 Container Demo with Docker Compose & Health Checks

A complete, ready-to-run .NET 8 Minimal Web API demonstrating containerization, multi-stage Docker builds, Docker Compose orchestration, and automated health checks.

---

## Project Structure

```text
CSharpContainer/
├── DemoApi.csproj               # .NET 8 Web API project file
├── Program.cs                   # Minimal API endpoints & Health Check configuration
├── appsettings.json             # Application configuration
├── appsettings.Development.json # Development configuration
├── Dockerfile                   # Multi-stage container build (with curl for health check)
├── docker-compose.yml           # Compose orchestration with service & healthcheck block
├── .dockerignore                # Build context exclusion rules
├── demo.sh                      # Shell script for automated live demo (macOS/Linux/WSL)
├── demo.ps1                     # PowerShell script for automated live demo (Windows)
└── README.md                    # Quickstart and demo run instructions
```

---

## Quickstart Instructions

When running on a machine with Docker Desktop / Docker Engine installed:

### 1. Build and Start the Container

```bash
docker compose up -d --build
```

### 2. Verify Container Status & Health Check

View the container status (Docker Compose will show `(health: starting)` then transition to `(healthy)`):

```bash
docker compose ps
```

You can also inspect the health status directly:

```bash
docker inspect --format='{{json .State.Health}}' demo-api
```

### 3. Test the Endpoints

#### Health Check Endpoint
```bash
curl -i http://localhost:8080/health
```
*Expected Output:* `HTTP/1.1 200 OK` with response body `Healthy`.

#### Weather Forecast Endpoint
```bash
curl -i http://localhost:8080/weatherforecast
```
*Expected Output:* JSON array of 5 weather forecasts.

#### Swagger UI (Browser)
Open your browser to:
[http://localhost:8080/swagger](http://localhost:8080/swagger)

---

### 4. Stop and Clean Up

```bash
docker compose down
```

---

## Automated Demo Scripts

For convenience during presentations:

- **Linux / macOS / WSL**:
  ```bash
  chmod +x demo.sh
  ./demo.sh
  ```
- **Windows (PowerShell)**:
  ```powershell
  .\demo.ps1
  ```
