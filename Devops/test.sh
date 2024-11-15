#!/bin/bash

# Set namespace for monitoring components
NAMESPACE="monitoring"

# Check Prometheus deployment
PROM_STATUS=$(kubectl get pods -n $NAMESPACE -l app=prometheus -o jsonpath="{.items[0].status.phase}")
if [ "$PROM_STATUS" == "Running" ]; then
  echo "Prometheus is running."
else
  echo "Prometheus is not running. Status: $PROM_STATUS"
fi

# Check Grafana deployment
GRAFANA_STATUS=$(kubectl get pods -n $NAMESPACE -l app=grafana -o jsonpath="{.items[0].status.phase}")
if [ "$GRAFANA_STATUS" == "Running" ]; then
  echo "Grafana is running."
else
  echo "Grafana is not running. Status: $GRAFANA_STATUS"
fi
