Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Starting .NET 8 Container Demo with Docker Compose" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

Write-Host "`n[1/4] Building and launching container..." -ForegroundColor Yellow
docker compose up -d --build

Write-Host "`n[2/4] Waiting for container health check to become healthy..." -ForegroundColor Yellow
$attempts = 0
$maxAttempts = 15
do {
    Start-Sleep -Seconds 2
    $status = (docker inspect --format='{{.State.Health.Status}}' demo-api 2>$null)
    Write-Host "  Current health status: $status"
    $attempts++
} until ($status -eq "healthy" -or $attempts -ge $maxAttempts)

Write-Host "`n[3/4] Container status:" -ForegroundColor Yellow
docker compose ps

Write-Host "`n[4/4] Testing health endpoint directly with curl/Invoke-RestMethod:" -ForegroundColor Yellow
try {
    $healthResponse = Invoke-WebRequest -Uri "http://localhost:8080/health" -UseBasicParsing
    Write-Host "Status Code: $($healthResponse.StatusCode)" -ForegroundColor Green
    Write-Host "Content: $($healthResponse.Content)" -ForegroundColor Green
} catch {
    Write-Host "Error reaching health endpoint: $_" -ForegroundColor Red
}

Write-Host "`nTesting weather endpoint:" -ForegroundColor Yellow
try {
    $weather = Invoke-RestMethod -Uri "http://localhost:8080/weatherforecast"
    $weather | Format-Table -AutoSize
} catch {
    Write-Host "Error reaching weather endpoint: $_" -ForegroundColor Red
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Demo complete! Swagger available at: http://localhost:8080/swagger" -ForegroundColor Cyan
Write-Host "To shut down: docker compose down" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
