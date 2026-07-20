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

Status: ✅ Completed

Completed

* Archive original workflow
* Create ci.yml (validate.yml)
* Create security.yml
* Split validation and security responsibilities

---

## Phase 3 — CI Improvements

Status: ✅ Completed

Completed

* Composite Actions (setup-helm, setup-kind, setup-kubectl, setup-kubeconform, helm-render)
* Reusable workspace configurations
* Modular and DRY pipelines

---

## Phase 4 — Platform Validation

Status: ✅ Completed

Completed

* kubeconform schema validation
* Helm lint
* Helm template rendering
* Kind ephemeral integration testing
* Kubernetes smoke tests with automated HTTP status verification

---

## Phase 5 — DevSecOps

Status: ✅ Completed

Completed

* Trivy IaC configuration scan
* Trivy third-party image vulnerability scan
* Gitleaks secret detection
* Software Bill of Materials (SBOM) generation via Syft

---

## Phase 6 — GitOps

Status: 🚧 In Progress

Completed

* GitOps engine comparative analysis (Argo CD vs Flux CD - ADR-0004)
* Declarative Argo CD bootstrap automation (`install-argocd.sh`)
* Native Multiple Sources configuration to separate upstream chart and local values config (`application.yaml`)
* Makefile integration (`argocd-bootstrap`, `argocd-status`, `argocd-port-forward`, `argocd-down`)

Pending

* Progressive delivery
* Rollbacks and automated self-healing validation

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

feature/phase4-gitops

Current Objective

Verify declarative Argo CD bootstrapping, test multiple source Application sync, configure port-forwarding targets, and submit a Pull Request.

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
