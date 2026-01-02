.PHONY: help docker-up docker-down docker-build docker-logs docker-clean ensure-repos ensure-frontend ensure-backend

# GitHub repository URLs (can be set via environment variables or edit this file)
# Example: export FRONTEND_REPO=https://github.com/yourusername/earniqa-frontend.git
FRONTEND_REPO ?= https://github.com/hhimalayaa/earniqa-frontend.git
BACKEND_REPO ?= https://github.com/hhimalayaa/earniqa-dev.git

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'Environment variables:'
	@echo '  FRONTEND_REPO  Frontend repository URL (default: $(FRONTEND_REPO))'
	@echo '  BACKEND_REPO   Backend repository URL (default: $(BACKEND_REPO))'

ensure-frontend: ## Ensure frontend repository is cloned
	@if echo "$(FRONTEND_REPO)" | grep -q "YOUR_USERNAME"; then \
		echo "Error: FRONTEND_REPO is not configured."; \
		echo "Please set FRONTEND_REPO environment variable or edit the Makefile."; \
		echo "Example: export FRONTEND_REPO=https://github.com/yourusername/earniqa-frontend.git"; \
		exit 1; \
	fi
	@if [ ! -d "frontend/.git" ]; then \
		if [ -d "frontend" ]; then \
			echo "Removing existing frontend directory (not a git repository)..."; \
			rm -rf frontend; \
		fi; \
		echo "Cloning frontend repository from $(FRONTEND_REPO)..."; \
		git clone $(FRONTEND_REPO) frontend || (echo "Error: Failed to clone frontend repository. Please check FRONTEND_REPO URL and ensure you have access." && exit 1); \
		echo "Frontend repository cloned successfully."; \
	else \
		echo "Frontend repository already exists."; \
	fi

ensure-backend: ## Ensure backend repository is cloned
	@if echo "$(BACKEND_REPO)" | grep -q "YOUR_USERNAME"; then \
		echo "Error: BACKEND_REPO is not configured."; \
		echo "Please set BACKEND_REPO environment variable or edit the Makefile."; \
		echo "Example: export BACKEND_REPO=https://github.com/yourusername/earniqa-dev.git"; \
		exit 1; \
	fi
	@if [ ! -d "backend/.git" ]; then \
		if [ -d "backend" ]; then \
			echo "Removing existing backend directory (not a git repository)..."; \
			rm -rf backend; \
		fi; \
		echo "Cloning backend repository from $(BACKEND_REPO)..."; \
		git clone $(BACKEND_REPO) backend || (echo "Error: Failed to clone backend repository. Please check BACKEND_REPO URL and ensure you have access." && exit 1); \
		echo "Backend repository cloned successfully."; \
	else \
		echo "Backend repository already exists."; \
	fi

ensure-repos: ensure-frontend ensure-backend ## Ensure both repositories are cloned

docker-up: ensure-repos ## Start all services with Docker Compose
	@echo "Starting all services..."
	docker-compose up -d
	@echo ""
	@echo "Services started!"
	@echo "  Frontend: http://localhost:3000"
	@echo "  Backend:  http://localhost:8080"
	@echo "  Database: localhost:3306"
	@echo "  NATS:     localhost:4222"
	@echo ""
	@echo "View logs: make docker-logs"

docker-up-build: ensure-repos ## Build and start all services
	@echo "Building and starting all services..."
	docker-compose up --build -d
	@echo ""
	@echo "Services started!"
	@echo "  Frontend: http://localhost:3000"
	@echo "  Backend:  http://localhost:8080"
	@echo "  Database: localhost:3306"
	@echo "  NATS:     localhost:4222"

docker-down: ## Stop all services
	docker-compose down

docker-build: ensure-repos ## Build all Docker images
	docker-compose build

docker-logs: ## View logs from all services
	docker-compose logs -f

docker-logs-frontend: ## View frontend logs
	docker-compose logs -f frontend

docker-logs-backend: ## View backend logs
	docker-compose logs -f backend

docker-logs-db: ## View database logs
	docker-compose logs -f db

docker-restart: ## Restart all services
	docker-compose restart

docker-clean: ## Stop and remove all containers, volumes, and networks
	docker-compose down -v
	@echo "Docker resources cleaned up"

docker-ps: ## Show running containers
	docker-compose ps

docker-shell-frontend: ## Open shell in frontend container
	docker-compose exec frontend sh

docker-shell-backend: ## Open shell in backend container
	docker-compose exec backend sh

