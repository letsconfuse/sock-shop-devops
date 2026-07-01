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
