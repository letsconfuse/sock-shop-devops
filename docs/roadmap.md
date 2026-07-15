# Shop DevOps - Platform Engineering Roadmap

## Vision

Transform this repository into a production-grade Platform Engineering repository demonstrating enterprise DevOps practices.

The goal is not only to deploy the Astronomy Shop application, but to build the surrounding engineering platform exactly like a real DevOps team would.

---

## Current Status

## Repository

* [x] Repository created
* [x] Git branching strategy
* [x] Pull Request workflow
* [x] Repository standards

## Repository Standards

Completed

* [x] .editorconfig
* [x] .gitattributes
* [x] LICENSE
* [x] SECURITY.md
* [x] CONTRIBUTING.md
* [x] CODEOWNERS

---

## Phase 1 — Repository Quality

Status: ✅ Completed

Implemented

* pre-commit
* yamllint
* markdownlint
* shellcheck
* actionlint

Repository now performs quality validation before every commit.

---

## Phase 2 — GitHub Actions Refactor

Status: 🚧 In Progress

Completed

* Archive original workflow
* Create ci.yml
* Create security.yml
* Split validation and security responsibilities

Pending

* Push workflows to GitHub
* Verify Actions
* Fix workflow failures
* Merge Pull Request

---

## Phase 3 — CI Improvements

Planned

* Composite Actions
* Reusable Workflows
* Dependency caching
* Parallel jobs
* Matrix builds
* Artifact uploads
* Helm caching
* Better failure reporting

---

## Phase 4 — Platform Validation

Planned

* kubeconform
* kube-linter
* Helm lint
* Helm template
* Kind integration testing
* Kubernetes smoke tests

---

## Phase 5 — DevSecOps

Planned

* Trivy
* Trufflehog
* Gitleaks
* Detect Secrets
* SBOM
* Cosign
* SLSA Provenance
* OPA / Conftest

---

## Phase 6 — GitOps

Planned

* ArgoCD
* FluxCD comparison
* Progressive delivery
* Rollbacks
* Health checks

---

## Phase 7 — Observability

Planned

* Prometheus
* Grafana
* Loki
* Tempo
* Jaeger
* OpenTelemetry
* Alertmanager

---

## Phase 8 — Release Engineering

Planned

* Semantic Versioning
* Conventional Commits
* Changelog generation
* GitHub Releases
* Release automation

---

## Phase 9 — Infrastructure

Planned

* Terraform
* Remote State
* AWS
* IAM
* Networking
* EKS
* GitHub OIDC

---

## Phase 10 — Production Readiness

Planned

* Disaster Recovery
* Backup Strategy
* Multi Environment
* Secrets Management
* Monitoring
* Cost Optimization

---

## Learning Objectives

By the end of this repository the following skills should be demonstrated.

## Git

* Branching
* PR workflow
* Reviews
* Git history

## GitHub

* Actions
* Environments
* Secrets
* Reusable workflows
* Composite actions

## Kubernetes

* Helm
* Kind
* Deployments
* StatefulSets
* Services
* Ingress
* ConfigMaps
* Secrets

## Security

* Supply Chain Security
* Image Scanning
* Secret Scanning
* SBOM
* Signing

## DevOps

* CI
* CD
* GitOps
* Release Engineering
* Platform Engineering

---

## Current Task

Current Branch

feature/ci-refactor

Current Objective

Push the refactored GitHub Actions workflows to GitHub.

Create a Pull Request.

Review failures.

Fix failures.

Merge after validation.

---

## Rules

Always work through Pull Requests.

Never push directly to main.

Every feature gets its own branch.

Every change must pass local pre-commit checks.

Every PR must pass GitHub Actions.

Never merge failing pipelines.

---

## Definition of Done

The repository should resemble a real enterprise Platform Engineering repository and be suitable to showcase during DevOps interviews.
