#!/bin/bash

echo "==============================="
echo " Homelab Health Check"
echo " $(date)"
echo "==============================="

check_service() {
  NAME=$1
  URL=$2
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 $URL)
  if [[ "$STATUS" =~ ^(200|301|302|303|401|403)$ ]]; then
    echo "[ OK ] $NAME ($STATUS)"
  else
    echo "[FAIL] $NAME ($STATUS)"
  fi
}

check_service "Jellyfin"    "http://192.168.56.12:30096"
check_service "Grafana"     "http://192.168.56.12:30300"
check_service "Prometheus"  "http://192.168.56.12:30090"
check_service "Pihole"      "http://192.168.56.12:30080"
check_service "Gitea"       "http://192.168.56.12:30400"
check_service "Uptime-Kuma" "http://192.168.56.12:30301"

echo "==============================="
