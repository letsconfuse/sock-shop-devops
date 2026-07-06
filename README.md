# DevOps Portfolio Project — Sock Shop Full Deployment

> GitHub: [github.com/letsconfuse](https://github.com/letsconfuse)

## Project Summary
A full production-style deployment of the **Sock Shop** microservices application. This project demonstrates end-to-end DevOps practices including containerization, local orchestration, CI/CD, Kubernetes deployment, Infrastructure as Code (IaC), and Observability.

## Architecture
*(Architecture diagram will be added here)*

## ech Stack

| Area | Tool | Why |
|---|---|---|
| Containerization | **Docker** | Package each service into an image |
| Local orchestration | **Docker Compose** | Run all services together locally |
| CI/CD | **GitHub Actions** | Automate build, test, and deploy on every push |
| Container registry | **Docker Hub** | Store and version built images |
| Orchestration | **Kubernetes (Minikube → Kind → Cloud)** | Production-style container management |
| IaC | **Terraform** | Provision cloud infrastructure as code |
| Monitoring | **Prometheus + Grafana** | Metrics collection and dashboards |
| Testing in pipeline | **Playwright / Bruno** | Smoke tests run automatically post-deploy |

## 🚀 How to Run Locally

You can spin up the entire microservices architecture locally using Docker Compose.

1. Clone this repository and navigate to the project directory:
   ```bash
   git clone https://github.com/letsconfuse/sock-shop-devops.git
   cd sock-shop-devops
   ```
2. Run the application:
   ```bash
   docker-compose -f docker/docker-compose.yml up -d
   ```
3. Access the front-end application in your browser at `http://localhost:8079`.

To tear down the environment, run:
```bash
docker-compose -f docker/docker-compose.yml down
```

## 🔄 CI/CD Pipeline

The project utilizes GitHub Actions for continuous integration and continuous deployment, separated into two workflows:

1. **Pull Request Pipeline (`ci.yml`)**:
   - Triggers on PRs to `main`.
   - Lints YAML and Dockerfiles (using `yamllint` and `hadolint`).
   - Builds the custom `front-end` image.
   - Spins up the entire application locally using `docker-compose`.
   - Runs automated Bruno API smoke tests against the ephemeral environment.

2. **Deployment Pipeline (`cd.yml`)**:
   - Triggers on merges to `main`.
   - Runs the same lint, build, and test steps as the CI pipeline.
   - Upon successful testing, securely authenticates with Docker Hub using GitHub Secrets.
   - Pushes the new Docker image tagged with the Git SHA and `latest`.

## Monitoring
*(Grafana screenshots and metrics will be added in Phase 5)*

## What I Learned
*(Ongoing reflections and learning outcomes will be documented here)*
