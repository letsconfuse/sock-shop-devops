#!/usr/bin/env bash
set -eo pipefail

echo "Running smoke tests..."

# Ensure we're in the right namespace
NAMESPACE="astronomy-shop"

# We will wait for the frontendproxy to be ready.
echo "Waiting for frontendproxy deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/astronomy-shop-frontendproxy -n "$NAMESPACE" || kubectl wait --for=condition=available --timeout=300s deployment/frontendproxy -n "$NAMESPACE"

# Port forward in the background
echo "Port-forwarding frontendproxy service..."
(kubectl port-forward svc/astronomy-shop-frontendproxy 8080:8080 -n "$NAMESPACE" || kubectl port-forward svc/frontendproxy 8080:8080 -n "$NAMESPACE") &
PORT_FORWARD_PID=$!

# Give it a second to establish the connection
sleep 5

echo "Testing frontend HTTP response..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Smoke test passed! Frontend returned 200 OK."
    kill $PORT_FORWARD_PID
    exit 0
else
    echo "❌ Smoke test failed! Frontend returned HTTP $HTTP_STATUS."
    kill $PORT_FORWARD_PID
    exit 1
fi
