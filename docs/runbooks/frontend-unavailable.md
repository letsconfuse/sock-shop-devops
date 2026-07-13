# Runbook: storefront unavailable

## Trigger

The Astronomy Shop storefront cannot be reached through the local port-forward or the frontend proxy has no ready endpoints.

## First checks

```bash
kubectl get pods -n astronomy-shop
kubectl get svc,endpoints -n astronomy-shop
kubectl describe pod -n astronomy-shop -l app.kubernetes.io/component=frontend-proxy
kubectl logs -n astronomy-shop -l app.kubernetes.io/component=frontend-proxy --tail=100
```

## Diagnose

1. If the pod is `Pending`, inspect events and check local Docker Desktop CPU/memory allocation.
2. If the pod is restarting, read the previous container logs with `kubectl logs --previous`.
3. If endpoints are empty, inspect readiness failures and labels on the Service and Pods.
4. If the proxy is healthy but requests fail, use Jaeger to trace the request and locate the downstream service.

## Recover

For a transient demo failure, delete only the failed pod and allow the Deployment to recreate it:

```bash
kubectl delete pod -n astronomy-shop <failed-pod-name>
kubectl rollout status deployment -n astronomy-shop <deployment-name>
```

If a chart upgrade caused the fault, inspect revisions and roll back:

```bash
helm history astronomy-shop -n astronomy-shop
make rollback
```

## Verify

Run `make status`, restart `make port-forward`, and load http://localhost:8080. Confirm a new request appears in Jaeger.
