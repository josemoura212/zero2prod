$RUNNING_CONTAINER = (docker ps --filter 'name=redis' --format '{{.ID}}')
if ($RUNNING_CONTAINER) {
    Write-Host "There is a redis container already running, kill it with"
    Write-Host "docker kill $RUNNING_CONTAINER"
    exit 1
}

# Launch Redis using Docker
docker run `
-p "6379:6379" `
-d `
--name "redis_zero2prod" `
redis:6

Write-Host "Redis is ready to go!"