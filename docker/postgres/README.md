### PostgreSQL Service

PostgreSQL database service for Ocean project using Docker Compose.

### Prerequisites

- Docker Desktop installed
- Docker Compose V2

### Directory Structure

```
docker/postgres/
├── secrets/
│   ├── .env
│   └── .env.example
├── compose.yml
└── README.md
```

### Setup

### 1. Create Environment File

Copy the example environment file and configure it:

```powershell
# Copy example file
Copy-Item -Path "secrets\.env.example" -Destination "secrets\.env"

# Edit the .env file with your credentials
notepad secrets\.env
```

Update the `.env` file with your database credentials:

### 2. Start the Service

From the project root:

```powershell
docker compose up -d postgres
```

### 3. Verify Health

```powershell
docker compose ps
docker logs postgres
```

### Configuration

- **Database**: oceandb (configurable via `POSTGRES_DB`)
- **User**: oceanuser (configurable via `POSTGRES_USER`)
- **Port**: 5432 (internal only)
- **Volume**: ocean-data
- **Network**: ocean-network

### Health Check

The service includes a health check that:
- Runs every 10 seconds
- Times out after 5 seconds
- Retries 5 times
- Has a 15-second start period

### Security Notes

⚠️ **Important**: 
- Never commit `secrets/.env` file to git
- The `.env` file is already in `.gitignore`
- Use strong passwords in production
- Consider using external secret management in production
- Always use the `.env.example` as a template

### Useful Commands

```powershell
# View logs
docker compose logs postgres -f

# Execute SQL
docker compose exec postgres psql -U oceanuser -d oceandb

# Stop service
docker compose stop postgres

# Remove service and data
docker compose down -v
```