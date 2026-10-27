#!/usr/bin/env bash
set -e

echo "======================================================"
echo "Starting .NET 8 Container Demo with Docker Compose"
echo "======================================================"

echo ""
echo "[1/4] Building and launching container..."
docker compose up -d --build

echo ""
echo "[2/4] Waiting for container health check to become healthy..."
attempts=0
max_attempts=15
until [ "$attempts" -ge "$max_attempts" ]
do
    status=$(docker inspect --format='{{.State.Health.Status}}' demo-api 2>/dev/null || echo "starting")
    echo "  Current health status: $status"
    if [ "$status" = "healthy" ]; then
        break
    fi
    attempts=$((attempts+1))
    sleep 2
done

echo ""
echo "[3/4] Container status:"
docker compose ps

echo ""
echo "[4/4] Testing health endpoint directly with curl:"
curl -i http://localhost:8080/health

echo ""
echo ""
echo "Testing weather endpoint:"
curl -s http://localhost:8080/weatherforecast | grep -o '^{' || curl -i http://localhost:8080/weatherforecast

echo ""
echo ""
echo "======================================================"
echo "Demo complete! Swagger available at: http://localhost:8080/swagger"
echo "To shut down: docker compose down"
echo "======================================================"
