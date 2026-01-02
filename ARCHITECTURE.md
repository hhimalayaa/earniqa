# EarniQA Docker Architecture

## Overview

EarniQA uses a **centralized Docker orchestration** approach where all Docker-related infrastructure is managed in the `earniqa` repository.

## Repository Structure

### 1. earniqa (Centralized Docker Orchestration)

**Purpose:** Single source of truth for all Docker deployments

**Contains:**
- `docker-compose.yml` - Complete stack orchestration (frontend, backend, db, nats)
- `docker/seed.sql` - Database initialization script
- `Makefile` - Automation scripts for common tasks
- Documentation (README.md, etc.)

**Responsibilities:**
- Service orchestration
- Database setup and seeding
- Network configuration
- Volume management
- Deployment automation

### 2. earniqa-frontend (Frontend Application)

**Purpose:** Frontend React/TypeScript application

**Contains:**
- Application source code
- `Dockerfile` - Frontend image build configuration
- Application-specific configuration

**Does NOT contain:**
- `docker-compose.yml` files (not needed - handled by earniqa repo)
- Database seed files (moved to earniqa repo)
- Infrastructure configuration

### 3. earniqa-dev (Backend Application)

**Purpose:** Backend Go API service

**Contains:**
- Application source code
- `Dockerfile` - Backend image build configuration
- Application-specific configuration

**Does NOT contain:**
- `docker-compose.yml` files (not needed - handled by earniqa repo)
- Infrastructure configuration

## Why Centralized?

### Benefits

1. **Single Source of Truth:** All Docker configuration in one place
2. **Easier Updates:** Update infrastructure without touching application repos
3. **Consistency:** Everyone uses the same Docker setup
4. **Simplified Onboarding:** One repository to clone for Docker setup
5. **Separation of Concerns:** Application repos focus on code, not infrastructure

### Migration from Distributed Setup

Previously, the frontend repository contained its own `docker-compose.yml` files. These have been centralized to the `earniqa` repository:

- ✅ `docker-compose.yml` → Moved to earniqa repo
- ✅ `docker/seed.sql` → Moved to earniqa repo
- ✅ Service orchestration → Managed in earniqa repo
- ✅ Application Dockerfiles → Remain in respective repos (needed for building images)

## Usage

### For End Users

```bash
# Clone the centralized repository
git clone <earniqa-repo-url>
cd earniqa

# Start everything (repos cloned automatically)
make docker-up
```

### For Developers

**To update infrastructure:**
- Make changes in the `earniqa` repository
- Update `docker-compose.yml`, `docker/seed.sql`, etc.

**To update applications:**
- Make changes in respective application repositories
- Update `earniqa-frontend` for frontend changes
- Update `earniqa-dev` for backend changes
- Docker images are rebuilt automatically

## Directory Structure

```
earniqa/                          # Centralized Docker repo
├── docker-compose.yml            # Main orchestration file
├── docker/
│   └── seed.sql                  # Database seed (centralized)
├── Makefile                      # Automation
├── README.md
│
├── frontend/                     # Cloned from earniqa-frontend
│   ├── Dockerfile                # Image build config
│   ├── src/                      # Application code
│   └── package.json
│
└── backend/                      # Cloned from earniqa-dev
    ├── Dockerfile                # Image build config
    ├── cmd/                      # Application code
    └── go.mod
```

## Service Communication

All services communicate via Docker network:

- Frontend → Backend: `http://backend:8080`
- Backend → Database: `earniqa:earniqa@tcp(db:3306)/earniqa`
- Backend → NATS: `nats://nats:4222`

## Database Seeding

Database is automatically seeded on first startup:

1. MySQL container starts
2. Automatically executes `docker/seed.sql` from `/docker-entrypoint-initdb.d/`
3. Seed file runs only on first volume creation
4. To reseed: `docker-compose down -v && docker-compose up -d`

## Future Considerations

If needed, you could:
- Add development vs production docker-compose overrides
- Add environment-specific configurations
- Add monitoring/logging services
- Add backup/restore scripts

All of these would be added to the `earniqa` repository, keeping the architecture centralized.

