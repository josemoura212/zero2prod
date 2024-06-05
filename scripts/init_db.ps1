# Check if sqlx is installed
# if (!(Get-Command psql -ErrorAction SilentlyContinue)) {
#     Write-Host "Error: psql is not installed."
#     exit 1
# }

if (!(Get-Command sqlx -ErrorAction SilentlyContinue)) {
    Write-Host "Error: sqlx is not installed."
    Write-Host "Use:"
    Write-Host " cargo install --version=0.5.7 sqlx-cli --no-default-features --features native-tls,postgres"
    Write-Host "to install it."
    exit 1
}

# Check if a custom user has been set, otherwise default to 'postgres'
$DB_USER = if ($env:POSTGRES_USER) { $env:POSTGRES_USER } else { 'postgres' }
# Check if a custom password has been set, otherwise default to 'password'
$DB_PASSWORD = if ($env:POSTGRES_PASSWORD) { $env:POSTGRES_PASSWORD } else { 'password' }
# Check if a custom database name has been set, otherwise default to 'newsletter'
$DB_NAME = if ($env:POSTGRES_DB) { $env:POSTGRES_DB } else { 'newsletter' }
# Check if a custom port has been set, otherwise default to '5432'
$DB_PORT = if ($env:POSTGRES_PORT) { $env:POSTGRES_PORT } else { '5432' }

$env:DATABASE_URL = "postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}"
$env:PGPASSWORD = "${DB_PASSWORD}"

# Launch postgres using Docker

if (-not ${env:SKIP_DOCKER}) {
    docker run `
    --name postgres_zero2prod `
    -e POSTGRES_USER=$DB_USER `
    -e POSTGRES_PASSWORD=$DB_PASSWORD `
    -e POSTGRES_DB=$DB_NAME `
    -p "${DB_PORT}:5432" `
    -d postgres `
    postgres -N 1000
}

$env:PGPASSWORD = "$DB_PASSWORD"
# while (!(psql -h "localhost" -U "$DB_USER" -p "$DB_PORT" -d "postgres" -c '\q')) {
#     Write-Host "Postgres is still unavailable - sleeping"
#     Start-Sleep -s 1
# }

Write-Host "Postgres is up and running on port $DB_PORT - running migrations now!"

# sqlx database create
# sqlx migrate add create_subscriptions_table
sqlx migrate run
Write-Host "O Postgres foi migrado, pronto para ser usado!" 