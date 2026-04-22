#!/bin/bash

echo "==============================="
echo " K3s Cluster Status"
echo " $(date)"
echo "==============================="

echo ""
echo "--- Nodes ---"
kubectl get nodes

echo ""
echo "--- All Pods ---"
kubectl get pods -A

echo ""
echo "--- Services ---"
kubectl get svc -A

echo ""
echo "--- Disk Usage ---"
df -h /

echo ""
echo "--- Memory Usage ---"
free -h

echo "==============================="
