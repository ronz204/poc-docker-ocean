### PostgreSQL Service

PostgreSQL database service for Ocean project using Docker Compose.

### Prerequisites

- Docker Desktop installed
- Docker Compose V2

### Directory Structure

```
docker/postgres/
├── secrets/
│   ├── username.txt
│   └── password.txt
├── compose.yml
└── README.md
```

### Setup

### 1. Create Secrets

Create the secrets directory and files:

```powershell
# Create secrets directory
New-Item -Path "secrets" -ItemType Directory -Force

# Create username secret
Set-Content -Path "secrets\username.txt" -Value "oceanuser" -NoNewline

# Create password secret
Set-Content -Path "secrets\password.txt" -Value "ocean1234" -NoNewline
```

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

- **Database**: oceandb
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
- Never commit `secrets/` directory to git
- Add `secrets/` to `.gitignore`
- Use strong passwords in production
- Consider using external secret management in production

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