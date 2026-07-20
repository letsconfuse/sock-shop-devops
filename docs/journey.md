# DevOps Learning Journey

## Purpose

This document records the engineering decisions, problems encountered, and lessons learned while building this repository.

It serves as a technical journal and interview reference.

---

## 2026-07-15

### Repository Foundation

Completed:

* Repository standards
* EditorConfig
* Git Attributes
* CODEOWNERS
* CONTRIBUTING
* SECURITY
* LICENSE

Added quality gates:

* pre-commit
* yamllint
* markdownlint
* actionlint
* shellcheck

Lesson learned:

Quality should be enforced before code reaches GitHub.

---

### CI Refactor

Archived the original workflow.

Split the monolithic workflow into:

* ci.yml
* security.yml

Reason:

Each workflow should have a single responsibility.

Benefits:

* Easier debugging
* Faster execution
* Better scalability
* Cleaner pipeline

---

### Challenges

Python on Ubuntu (PEP 668)

Issue:

System Python prevented installing packages globally.

Solution:

Created a Python virtual environment.

Used:

python -m pip

instead of:

pip

---

### Tooling Installed

* Git
* Docker
* Helm
* Kind
* kubectl
* Go
* actionlint
* pre-commit
* yamllint
* markdownlint

---

## 2026-07-20

### GitOps with Argo CD

Completed:

* Evaluated GitOps tools (Argo CD vs Flux CD) and detailed choices in ADR-0004.
* Created declarative installer `platform/argocd/install-argocd.sh` to configure the namespace, pull stable manifests, wait for rollout, and bootstrap application.
* Implemented multiple-source `platform/argocd/application.yaml` linking the official OpenTelemetry demo Helm repository to our local values file configuration.
* Added `argocd-*` targets to Makefile for easy lifecycle management.

Lesson learned:

Using Argo CD's Multiple Sources feature is a powerful way to reference upstream Helm charts while maintaining custom value overrides in a separate Git repository, keeping the codebase clean and eliminating local wrapper charts.

---

## Next Objective

Push the `feature/phase4-gitops` branch, run validation and security checks, and merge the Pull Request.

