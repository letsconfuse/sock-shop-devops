# 3. Security Scanning Strategy

Date: 2026-07-16

## Status

Accepted

## Context

A secure platform requires continuous security feedback. Since this is an infrastructure repository (`shop-devops`), we do not compile application binaries. However, we do store infrastructure-as-code (IaC) configurations, deployment manifests, and scripts. We need a strategy to automatically detect:
1.  Secrets or credentials accidentally committed to the git history.
2.  Misconfigurations in our Kubernetes manifests and Helm values.
3.  Vulnerabilities in the third-party container images we deploy.
4.  Generate a Software Bill of Materials (SBOM) to document our software supply chain.

## Decision

We will implement a multi-layered security checking workflow (`security.yml`) triggered on every pull request and push to the main branch:

1.  **Secret Detection:** We will use **Gitleaks** via its official GitHub Action. Gitleaks is chosen for its speed and accuracy in scanning git history and commits for secrets.
2.  **Configuration Scan:** We will use **Trivy** to scan our `platform` directory. Trivy scans Kubernetes manifests, Helm values, and Dockerfiles for security risks (e.g., containers running as root, privileged mode, etc.).
3.  **Vulnerability Scan:** We will parse the container images referenced in our deployment and run Trivy image scans on them. To avoid blocking our CI pipeline on third-party vulnerabilities we cannot fix, we will log findings for all images (setting exit-code to `0`) but keep visibility high.
4.  **Software Bill of Materials (SBOM):** We will use the **Anchore SBOM Action** (powered by Syft) to generate an SBOM artifact for our repository, adhering to security compliance standards.

## Consequences

*   **Positive:** Prevents leaks of API keys, database credentials, and other secrets.
*   **Positive:** Identifies risky Kubernetes configurations before they hit a cluster.
*   **Positive:** Validates the security posture of third-party images we deploy and registers vulnerabilities for monitoring.
*   **Negative:** Adds execution time to the CI workflow.
*   **Negative:** Gitleaks scans can sometimes flag false positives (e.g., test keys), which will require maintaining a `.gitleaksignore` file.
*   **Neutral:** Because we do not fail the build on third-party CVEs (exit-code 0), we must rely on manual reviews of the security logs to upgrade the Helm chart when critical patches are released.
