#!/bin/bash

# Set namespace for monitoring components
NAMESPACE="monitoring"

# Create namespace if it doesn't exist
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Deploy Prometheus configuration and service
echo "Deploying Prometheus..."
kubectl apply -f ../prometheus-config.yaml -n $NAMESPACE

# Deploy Grafana
echo "Deploying Grafana..."
kubectl apply -f ../grafana-deployment.yaml -n $NAMESPACE

echo "Monitoring stack deployed successfully!"
