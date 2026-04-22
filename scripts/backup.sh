#!/bin/bash

BACKUP_DIR="/home/jgreene/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "==============================="
echo " Homelab Backup - $DATE"
echo "==============================="

# Backup Gitea
echo "[*] Backing up Gitea..."
tar -czf $BACKUP_DIR/gitea_$DATE.tar.gz /home/jgreene/gitea
echo "[ OK ] Gitea backup saved to $BACKUP_DIR/gitea_$DATE.tar.gz"

# Backup k3s manifests
echo "[*] Backing up k3s manifests..."
tar -czf $BACKUP_DIR/manifests_$DATE.tar.gz /home/jgreene/homelab-repo
echo "[ OK ] Manifests backup saved to $BACKUP_DIR/manifests_$DATE.tar.gz"

# Backup Prometheus config
echo "[*] Backing up Prometheus config..."
tar -czf $BACKUP_DIR/prometheus_$DATE.tar.gz /home/jgreene/prometheus
echo "[ OK ] Prometheus backup saved"

# Cleanup backups older than 7 days
echo "[*] Cleaning up old backups..."
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
echo "[ OK ] Old backups cleaned up"

echo "==============================="
echo " Backup Complete"
echo "==============================="
