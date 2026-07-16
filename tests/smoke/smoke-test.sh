#!/usr/bin/env bash
set -eo pipefail

echo "Running smoke tests..."

# Ensure we're in the right namespace
NAMESPACE="astronomy-shop"

# We will wait for the frontend-proxy to be ready.
echo "Waiting for frontend-proxy deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/astronomy-shop-frontend-proxy -n "$NAMESPACE" || kubectl wait --for=condition=available --timeout=300s deployment/frontend-proxy -n "$NAMESPACE" || kubectl wait --for=condition=available --timeout=300s deployment/astronomy-shop-frontendproxy -n "$NAMESPACE"

# Port forward in the background
echo "Port-forwarding frontend-proxy service..."
(kubectl port-forward svc/astronomy-shop-frontend-proxy 8080:8080 -n "$NAMESPACE" || kubectl port-forward svc/frontend-proxy 8080:8080 -n "$NAMESPACE" || kubectl port-forward svc/astronomy-shop-frontendproxy 8080:8080 -n "$NAMESPACE") &
PORT_FORWARD_PID=$!

# Give it a second to establish the connection
sleep 5

echo "Testing frontend HTTP response (with retries for startup)..."
MAX_RETRIES=15
RETRY_COUNT=0
HTTP_STATUS=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/)
    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "✅ Smoke test passed! Frontend returned 200 OK."
        kill $PORT_FORWARD_PID
        exit 0
    fi
    echo "Frontend returned HTTP $HTTP_STATUS (attempt $((RETRY_COUNT+1))/$MAX_RETRIES). Waiting..."
    sleep 5
    RETRY_COUNT=$((RETRY_COUNT+1))
done

echo "❌ Smoke test failed! Frontend returned HTTP $HTTP_STATUS after $MAX_RETRIES attempts."
kill $PORT_FORWARD_PID
exit 1
