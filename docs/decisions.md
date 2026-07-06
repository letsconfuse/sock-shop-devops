# Architecture & Design Decisions

This document records the reasoning behind technical choices made throughout the project.

## Phase 1: Docker & Containerization

### 1. `docker-compose.yml` from scratch
- **Decision**: Wrote a custom `docker-compose.yml` instead of using the provided one in the Sock Shop repo.
- **Why**: The default compose file is heavily abstracted and contains old configurations. Writing it from scratch enforces a deep understanding of how the 13+ microservices communicate (e.g., `orders` needing `rabbitmq` and `orders-db`).
- **Networking**: Placed all services on a single custom bridge network (`sock-shop`) so they can resolve each other by container name (DNS).

### 2. Dockerfile Optimization
- **Decision**: Extracted and optimized the `front-end` Dockerfile.
- **Why**: The original Dockerfile used an outdated `node:10-alpine` and built everything in a single stage.
- **Optimizations Applied**:
  - **Multi-stage builds**: Used a `builder` stage to install dependencies, ensuring `devDependencies` and cached files don't bloat the final image.
  - **Non-root user**: Enforced running as `appuser` (instead of root) to limit the blast radius if the container is compromised.
  - **Node Version**: Bumped to `node:14-alpine` for better security and performance while maintaining compatibility.

## Phase 2: CI/CD Pipeline with GitHub Actions

### 1. Separate CI and CD Workflows
- **Decision**: Created `ci.yml` for pull requests and `cd.yml` for pushes to `main`.
- **Why**: PRs should only validate code (lint and test) without side effects. Only merges to `main` should push artifacts to Docker Hub. This prevents unreviewed code from overwriting images.

### 2. Linting and Automated Testing in Pipeline
- **Decision**: Used `hadolint` for Dockerfiles and `yamllint` for YAML files, followed by an automated integration test using Bruno.
- **Why**: Fails the pipeline fast if there are syntax errors or non-compliance with Docker best practices. The Bruno tests run against a spun-up `docker-compose` instance, ensuring the newly built image actually works with the rest of the microservices before pushing to Docker Hub.

### 3. Secrets Management
- **Decision**: Hardcoded no credentials. Docker Hub credentials will be injected dynamically via GitHub Secrets (`DOCKER_USERNAME` and `DOCKER_PASSWORD`).

## Phase 3: Kubernetes Deployment

### 1. Separation of Concerns in Manifests
- **Decision**: Split configuration logically across `deployments/`, `services/`, `ingress/`, and `configmaps/`.
- **Why**: This mimics enterprise environments where different teams or pipelines might manage ingress vs. core application deployments.

### 2. Rollout Strategy
- **Decision**: Defined `maxSurge: 1` and `maxUnavailable: 0` in the `front-end` deployment's RollingUpdate strategy.
- **Why**: Ensures zero downtime during deployments. Kubernetes will spin up a new pod with the latest image before terminating the old one.

### 3. GitOps-Style Pipeline Integration
- **Decision**: The CD pipeline uses `kubectl apply -f` on the manifest directories, followed by a `kubectl set image` to force the newly built image SHA.
- **Why**: Guarantees that what is defined in the repository exactly matches what is running in the cluster.

## Phase 4: Infrastructure as Code (Terraform)

### 1. Cloud Provider and Provisioning
- **Decision**: Used AWS (EC2 `t2.micro` for free-tier eligibility) to act as the cloud Kubernetes node (via Minikube/Kind installed on user-data bootstrap).
- **Why**: Shows understanding of cloud VMs, security groups, and bootstrapping scripts (`user_data`) without accruing cloud costs.

### 2. Remote State Management
- **Decision**: Configured the Terraform backend to use an S3 bucket (`sock-shop-terraform-state-bucket`) with DynamoDB state locking.
- **Why**: Remote state is mandatory for team environments. It prevents state corruption and concurrent runs from breaking infrastructure.

### 3. CI/CD Pipeline for Infrastructure
- **Decision**: Created a dedicated `.github/workflows/terraform.yml`.
- **Why**: Infrastructure changes should go through the same code review process as application code. The pipeline runs `terraform plan` on PRs (to review changes) and `terraform apply` only when merged to `main`.
