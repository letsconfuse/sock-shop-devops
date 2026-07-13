# Roadmap

## Implemented locally

- Pinned upstream Astronomy Shop Helm deployment
- kind cluster definition
- Render, schema validation, configuration scanning, and SBOM CI checks
- Local-only access and a frontend availability runbook

## Next, after the local baseline is stable

1. Pin third-party GitHub Actions to full commit SHAs and manage updates through Dependabot.
2. Add a policy engine (Kyverno) and test policies against rendered manifests.
3. Add Prometheus alert rules and Alertmanager with a local webhook receiver.
4. Add a controlled failure test and document its expected telemetry.
5. Add GitHub Container Registry only when you build an application-owned image.

## Intentionally deferred

AWS, EKS, managed databases, and public ingress require an account, IAM design, and cost controls. They are not required to demonstrate the local DevOps platform and should not be claimed as implemented.
