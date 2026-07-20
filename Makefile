SHELL := /usr/bin/env bash
CLUSTER_NAME ?= astronomy-shop
NAMESPACE ?= astronomy-shop
RELEASE_NAME ?= astronomy-shop
CHART_REPOSITORY ?= open-telemetry/opentelemetry-demo

include platform/helm/versions.env
export

.DEFAULT_GOAL := help
.PHONY: help bootstrap validate scan up status port-forward rollback down argocd-bootstrap argocd-status argocd-port-forward argocd-down

help: ## Show available commands.
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-16s %s\n", $$1, $$2}'

bootstrap: ## Create a local kind cluster and add the official Helm repository.
	kind create cluster --name $(CLUSTER_NAME) --config platform/kind/cluster.yaml
	helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
	helm repo update

validate: ## Render the pinned chart and validate the generated Kubernetes manifests.
	helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
	helm repo update
	chart_dir=$$(mktemp -d); helm pull $(CHART_REPOSITORY) --version $(OTEL_DEMO_CHART_VERSION) --untar --untardir "$$chart_dir"; helm lint "$$chart_dir/opentelemetry-demo" --values platform/helm/values.yaml; helm template $(RELEASE_NAME) "$$chart_dir/opentelemetry-demo" --namespace $(NAMESPACE) --values platform/helm/values.yaml > /tmp/astronomy-shop-rendered.yaml
	kubectl apply --dry-run=client --validate=true -f /tmp/astronomy-shop-rendered.yaml

scan: ## Scan only this repository's platform configuration.
	docker run --rm -v "$(CURDIR):/work" -w /work aquasec/trivy:0.66.0 config --exit-code 1 --severity HIGH,CRITICAL platform

up: validate ## Install or upgrade the pinned Astronomy Shop chart.
	helm upgrade --install $(RELEASE_NAME) $(CHART_REPOSITORY) --version $(OTEL_DEMO_CHART_VERSION) --namespace $(NAMESPACE) --create-namespace --values platform/helm/values.yaml --wait --timeout 10m

status: ## Display Helm release state and workload readiness.
	helm status $(RELEASE_NAME) --namespace $(NAMESPACE)
	kubectl get pods --namespace $(NAMESPACE)

port-forward: ## Expose the storefront, Grafana, and Jaeger locally.
	@echo "Storefront: http://localhost:8080"
	@echo "Grafana:    http://localhost:8080/grafana/"
	@echo "Jaeger:     http://localhost:8080/jaeger/ui/"
	kubectl --namespace $(NAMESPACE) port-forward svc/$(RELEASE_NAME)-frontendproxy 8080:8080

rollback: ## Roll back the release by one revision after checking Helm history.
	helm history $(RELEASE_NAME) --namespace $(NAMESPACE)
	helm rollback $(RELEASE_NAME) 0 --namespace $(NAMESPACE) --wait --timeout 10m

down: ## Delete the complete local cluster and all of its resources.
	kind delete cluster --name $(CLUSTER_NAME)

argocd-bootstrap: ## Install Argo CD, wait for rollout, and deploy the application.
	./platform/argocd/install-argocd.sh

argocd-status: ## Display Argo CD application status and target workloads.
	@echo "=== Argo CD Application Status ==="
	kubectl get application astronomy-shop -n argocd -o wide || echo "Argo CD Application not found."
	@echo "=== Workload Status ==="
	kubectl get pods -n $(NAMESPACE)

argocd-port-forward: ## Expose Argo CD UI (https://localhost:8082) and storefront (http://localhost:8080).
	@echo "Argo CD UI:  https://localhost:8082"
	@echo "Storefront:  http://localhost:8080"
	@echo "Retrieving Argo CD admin password..."
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
	# Run port-forwards (Ctrl+C to terminate)
	kubectl port-forward svc/argocd-server -n argocd 8082:443 & \
	kubectl port-forward svc/$(RELEASE_NAME)-frontendproxy -n $(NAMESPACE) 8080:8080 & \
	wait

argocd-down: ## Delete Argo CD application and namespaces.
	kubectl delete -f platform/argocd/application.yaml --ignore-not-found=true
	kubectl delete namespace $(NAMESPACE) --ignore-not-found=true
	kubectl delete namespace argocd --ignore-not-found=true

