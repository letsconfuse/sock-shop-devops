SHELL := /usr/bin/env bash
CLUSTER_NAME ?= astronomy-shop
NAMESPACE ?= astronomy-shop
RELEASE_NAME ?= astronomy-shop
CHART_REPOSITORY ?= open-telemetry/opentelemetry-demo

include platform/helm/versions.env
export

.DEFAULT_GOAL := help
.PHONY: help bootstrap validate scan up status port-forward rollback down

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
