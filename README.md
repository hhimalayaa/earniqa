# EarniQA Docker Setup (Centralized Repository)

**This is the centralized Docker orchestration repository for EarniQA.**

This repository contains all Docker configuration files and scripts needed to run the complete EarniQA stack (frontend, backend, database, and messaging services). All Docker-related infrastructure is managed here, making it the single source of truth for Docker deployments.

📖 **For detailed architecture information, see [ARCHITECTURE.md](./ARCHITECTURE.md)**

## Prerequisites

- Docker Engine 20.10 or later
- Docker Compose 2.0 or later
- Git (for cloning and submodules)

## Architecture

**EarniQA uses a centralized Docker orchestration approach:**

- **earniqa** (this repository): Centralized Docker orchestration
  - Contains `docker-compose.yml` for the complete stack
  - Contains `docker/seed.sql` for database initialization
  - Contains `Makefile` for automation
  - Manages all Docker infrastructure

- **earniqa-frontend**: Frontend application repository
  - Contains application source code
  - Contains `Dockerfile` for building the frontend image
  - Does NOT need docker-compose files (handled by earniqa repo)

- **earniqa-dev**: Backend application repository
  - Contains application source code
  - Contains `Dockerfile` for building the backend image
  - Does NOT need docker-compose files (handled by earniqa repo)

## Project Structure

After setup, your directory structure will look like:

```
earniqa/                  # This repository (centralized Docker orchestration)
├── docker-compose.yml    # Main Docker Compose configuration
├── docker/
│   └── seed.sql          # Database seed file
├── Makefile              # Automation scripts
├── README.md
├── frontend/             # Cloned earniqa-frontend repository
│   ├── Dockerfile        # Frontend build configuration
│   └── src/              # Frontend source code
└── backend/              # Cloned earniqa-dev repository
    ├── Dockerfile        # Backend build configuration
    └── cmd/              # Backend source code
```

**Note:** The `frontend/` and `backend/` directories are cloned repositories (not part of this repo's git history). They're automatically managed by the Makefile.

## Setup Instructions

### Option 1: Using Make (Recommended - Easiest)

The Makefile automatically handles cloning the repositories when needed.

1. Clone this repository:

```bash
git clone <this-repo-url> earniqa
cd earniqa
```

2. Configure repository URLs (if needed):

Edit the `Makefile` and update the `FRONTEND_REPO` and `BACKEND_REPO` variables, OR export them as environment variables:

```bash
export FRONTEND_REPO=https://github.com/yourusername/earniqa-frontend.git
export BACKEND_REPO=https://github.com/yourusername/earniqa-dev.git
```

3. Start services (repositories will be cloned automatically if missing):

```bash
make docker-up
```

### Option 2: Using Git Submodules

This approach ensures everyone uses the correct versions of the frontend and backend repositories.

1. Clone this repository:

```bash
git clone <this-repo-url> earniqa
cd earniqa
```

2. Add the frontend and backend repositories as submodules:

```bash
git submodule add <earniqa-frontend-repo-url> frontend
git submodule add <earniqa-dev-repo-url> backend
```

3. Initialize and update submodules:

```bash
git submodule update --init --recursive
```

**Note:** If you've already cloned this repository and the submodules are already configured, just run:

```bash
git submodule update --init --recursive
```

### Option 3: Manual Clone

If you prefer to clone manually:

```bash
# Clone this repository
git clone <this-repo-url> earniqa
cd earniqa

# Clone frontend and backend into the expected directories
git clone <earniqa-frontend-repo-url> frontend
git clone <earniqa-dev-repo-url> backend
```

## Running the Services

### Quick Start (Recommended)

The easiest way to get started is using the Makefile, which automatically checks and clones the required repositories:

```bash
# Set your GitHub repository URLs (required)
export FRONTEND_REPO=https://github.com/yourusername/earniqa-frontend.git
export BACKEND_REPO=https://github.com/yourusername/earniqa-dev.git

# Start all services (will clone repos if needed)
make docker-up
```

The `make docker-up` command will:
1. Check if `frontend/` directory exists, clone it if missing
2. Check if `backend/` directory exists, clone it if missing
3. Start all Docker services

**Note:** You must configure the `FRONTEND_REPO` and `BACKEND_REPO` URLs either by:
- Exporting them as environment variables (as shown above), OR
- Editing the `Makefile` and updating the default values

### Using Docker Compose Directly

If you prefer to use docker-compose directly, ensure the repositories are cloned first:

```bash
docker-compose up -d
```

This will start:
- **backend** (earniqa-dev): Go API Gateway service (accessible at http://localhost:8080)
- **frontend**: Frontend application served via nginx (accessible at http://localhost:3000)
- **db**: MySQL database (accessible at localhost:3306)
- **nats**: NATS messaging server (accessible at localhost:4222)

### Start services with logs

```bash
docker-compose up
```

### Stop services

```bash
docker-compose down
```

### Available Make Commands

```bash
make help              # Show all available commands
make docker-up         # Start all services (clones repos if needed)
make docker-up-build   # Build and start all services
make docker-down       # Stop all services
make docker-build      # Build all Docker images
make docker-logs       # View logs from all services
make docker-logs-frontend  # View frontend logs
make docker-logs-backend   # View backend logs
make docker-logs-db        # View database logs
make docker-restart    # Restart all services
make docker-clean      # Stop and remove all containers, volumes, and networks
make docker-ps         # Show running containers
make ensure-repos      # Clone repositories if they don't exist
```

### Using Docker Compose Directly

```bash
# Rebuild and start services
docker-compose up --build -d

# View logs
docker-compose logs -f                    # All services
docker-compose logs -f frontend           # Frontend only
docker-compose logs -f backend            # Backend only
docker-compose logs -f db                 # Database only
docker-compose logs -f nats               # NATS only
```

## Services

- **backend** (earniqa-backend): Go API Gateway service (port 8080)
- **frontend** (earniqa-frontend): Frontend application served via nginx (port 3000)
- **db** (earniqa-mysql): MySQL 8 database (port 3306)
- **nats** (earniqa-nats): NATS server with JetStream (port 4222)

## Environment Variables

You can customize environment variables by:

1. Creating a `.env` file in the root directory
2. Modifying the `environment` section in `docker-compose.yml`

### Backend Environment Variables

The backend service uses the following environment variables:
- `DB_DRIVER`: Database driver (mysql)
- `MYSQL_DSN`: MySQL connection string
- `NATS_URL`: NATS server URL
- `JWT_SECRET`: JWT secret for authentication
- `PORT`: Service port (default: 8080)

Additional variables can be added (uncomment in docker-compose.yml):
- `STRIPE_SECRET_KEY`: Stripe API key
- `STRIPE_WEBHOOK_SECRET`: Stripe webhook secret
- `TELEGRAM_BOT_TOKEN`: Telegram bot token

### Frontend Environment Variables

- `VITE_API_BASE_URL`: Backend API URL (default: http://backend:8080)

## Customization

### Changing Ports

Edit the `ports` section in `docker-compose.yml`:

```yaml
ports:
  - "YOUR_PORT:80"    # frontend (nginx)
  - "YOUR_PORT:8080"  # backend
  - "YOUR_PORT:3306"  # database
  - "YOUR_PORT:4222"  # nats
```

### Database

The MySQL database is automatically initialized with the `earniqa` database. Data is persisted in a Docker volume (`mysql_data`). To reset the database:

```bash
docker-compose down -v  # Removes volumes
docker-compose up -d
```

## Troubleshooting

### Port already in use

If ports 3000, 8080, 3306, or 4222 are already in use, change them in `docker-compose.yml`.

### Container build fails

- Ensure `frontend/` and `backend/` directories exist in this repository
- If using git submodules, ensure they are initialized: `git submodule update --init --recursive`
- Check that the Dockerfiles exist in the `frontend/` and `backend/` directories
- Review the build logs: `docker-compose build --no-cache`

### Services can't communicate

- Ensure all services are on the same Docker network (configured in `docker-compose.yml`)
- Use service names (e.g., `backend`, `db`, `nats`) for internal communication, not `localhost`
- The frontend uses `VITE_API_BASE_URL=http://backend:8080` for API calls within Docker

### Database connection issues

- Wait for the database healthcheck to pass before backend starts
- Check database logs: `docker-compose logs db`
- Verify MySQL credentials match in the `MYSQL_DSN` environment variable

## Architecture Notes

### Centralized Docker Management

- **All Docker orchestration is centralized in this repository**
- The `docker-compose.yml` file in this repo is the **single source of truth** for Docker deployments
- Database seed file (`docker/seed.sql`) is managed here
- Frontend and backend repositories only need their `Dockerfile` files for building images
- The frontend/backend repos' own `docker-compose.yml` files are **not used** when running via this repository

### Repository Responsibilities

- **earniqa repository (this repo):**
  - Docker Compose orchestration
  - Database seeding
  - Service configuration
  - Deployment automation (Makefile)

- **earniqa-frontend repository:**
  - Frontend application code
  - Frontend Dockerfile (image build configuration)
  - Application-specific configuration

- **earniqa-dev repository:**
  - Backend application code
  - Backend Dockerfile (image build configuration)
  - Application-specific configuration

### Technical Details

- The backend service builds from `./backend` directory and uses the `api-gateway` service
- The frontend service builds from `./frontend` directory and uses nginx for serving
- Both `frontend/` and `backend/` directories must be present (automatically cloned by Makefile)
- The backend uses a Go multi-stage build with Alpine Linux (Go 1.25.3)
- The frontend uses Node.js 20 with Vite and nginx for production
- Database is automatically seeded with `docker/seed.sql` on first startup

