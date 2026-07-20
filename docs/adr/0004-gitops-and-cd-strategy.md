# 4. GitOps and Continuous Delivery Strategy

Date: 2026-07-20

## Status

Accepted

## Context

We need to establish a Continuous Delivery (CD) mechanism that aligns with GitOps principles. Rather than relying on manual scripts (`make up`) or push-based pipelines to apply changes directly to our Kubernetes cluster, the cluster state should be driven declaratively by the configurations stored in this Git repository. 

Our microservices application (Astronomy Shop) has 15+ services, making it crucial to have:
1. Automated sync policies to ensure the cluster matches Git configuration.
2. Drift detection and self-healing to automatically revert manual `kubectl` overrides.
3. High visibility into the deployment state, dependencies, and health of each microservice.

We evaluated two major CNCF GitOps tools: **Argo CD** and **Flux CD**.

### Argo CD vs. Flux CD Comparison

| Feature | Argo CD | Flux CD |
|---|---|---|
| **Architecture** | Centralized API Server & Controller (Pull-based) | Modular controllers (Source, Helm, Kustomize) |
| **User Interface** | Rich, interactive web UI out-of-the-box | CLI-first; requires third-party UI (e.g., Weave GitOps) |
| **Application Model** | Single CRD (`Application` / `ApplicationSet`) | Decoupled CRDs (`GitRepository`, `HelmRelease`) |
| **Multiple Sources** | Supported natively (v2.6+); simple configuration | Supported natively by decoupling sources and releases |
| **Visualization** | Excellent visualization of resource dependency trees | Minimal representation without third-party addons |
| **Reconciliation** | Instant webhook or periodic poll (default 3m) | Periodic reconciliation based on configured intervals |

## Decision

We will use **Argo CD** as our GitOps and CD engine for the local DevSecOps platform.

1.  **Multiple Sources Engine:** We will utilize Argo CD's Multiple Sources feature to point to the upstream Helm repository for the Astronomy Shop chart (`opentelemetry-demo`) while sourcing our custom configuration (`values.yaml`) directly from this Git repository. This avoids duplications and wrapper chart maintenance.
2.  **Automated Reconciliation:** We will enable automatic pruning (removing deleted resources) and self-healing (reverting manual cluster drift).
3.  **Visualization:** The Argo CD Web UI will be exposed via a port-forwarding target to provide developer-friendly visibility into the complex microservice landscape.

## Consequences

*   **Positive:** Single source of truth for the entire platform state. Manual changes to the cluster are automatically corrected.
*   **Positive:** Highly visual representation of the application structure, helping developers understand microservice dependencies.
*   **Positive:** No duplicate Helm values or complex umbrella charts required to use GitOps with upstream dependencies.
*   **Negative:** Increased local cluster footprint. Argo CD running controllers, Redis, and its API server will consume ~500MiB–1GiB of memory.
*   **Negative:** Requires managing Git access credentials in a production environment (not applicable here as we use a public repository and local cluster).
