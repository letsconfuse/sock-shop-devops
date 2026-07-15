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

## Next Objective

Push the CI refactor.

Review GitHub Actions.

Fix failures.

Merge the Pull Request.
