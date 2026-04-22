# Homelab Infrastructure

A personal homelab environment built on RHEL 10, running a Kubernetes (k3s) cluster with multiple self-hosted services managed via Terraform and version controlled in Gitea/GitHub.

## Stack Overview

| Service | Description | Port |
|---|---|---|
| Jellyfin | Self-hosted media server | 30096 |
| Grafana | Metrics visualization dashboard | 30300 |
| Prometheus | Metrics collection and alerting | 30090 |
| Pi-hole | Network-wide DNS ad blocking | 30080 |
| Gitea | Self-hosted Git server | 30400 |
| Uptime Kuma | Service uptime monitoring | 30301 |

## Infrastructure

- **OS:** Red Hat Enterprise Linux 10
- **Container Orchestration:** k3s (lightweight Kubernetes)
- **Infrastructure as Code:** Terraform with Kubernetes provider
- **Ingress Controller:** Traefik (bundled with k3s)
- **Container Runtime:** Podman / containerd
- **Monitoring:** Prometheus + Grafana + Node Exporter

## Repository Structure
## Prerequisites

- RHEL 10 VM (minimum 4 CPU, 8GB RAM, 30GB disk)
- k3s installed
- Terraform installed
- Podman installed
- Git installed

## Deployment

### 1. Install k3s

```bash
curl -sfL https://get.k3s.io | sh -
export PATH=$PATH:/usr/local/bin
```

### 2. Deploy services

```bash
# Create monitoring namespace
kubectl create namespace monitoring

# Deploy all services
kubectl apply -f jellyfin-k3s.yaml
kubectl apply -f prometheus.yaml
kubectl apply -f grafana.yaml
kubectl apply -f pihole.yaml
kubectl apply -f gitea.yaml
kubectl apply -f node-exporter.yaml
kubectl apply -f node-exporter-svc.yaml
kubectl apply -f ingress.yaml
```

### 3. Deploy via Terraform

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

### 4. Run Ansible playbook

```bash
ansible-playbook ansible/homelab-setup.yml
```

### 5. Open firewall ports

```bash
firewall-cmd --zone=public --add-port=30096/tcp --permanent
firewall-cmd --zone=public --add-port=30300/tcp --permanent
firewall-cmd --zone=public --add-port=30090/tcp --permanent
firewall-cmd --zone=public --add-port=30080/tcp --permanent
firewall-cmd --zone=public --add-port=30400/tcp --permanent
firewall-cmd --zone=public --add-port=30301/tcp --permanent
firewall-cmd --reload
```

## Monitoring

Prometheus scrapes metrics from:
- Prometheus itself (localhost:9090)
- Node Exporter (node metrics: CPU, memory, disk, network)

Grafana dashboards:
- **Node Exporter Full** (ID: 1860) — system metrics
- **Kubernetes cluster monitoring** (ID: 315) — cluster overview

## Scripts

### Health Check
```bash
./scripts/healthcheck.sh
```
Checks HTTP status of all services and reports UP/FAIL.

### Backup
```bash
./scripts/backup.sh
```
Backs up Gitea data, k3s manifests, and Prometheus config to `/home/jgreene/backups`. Automatically removes backups older than 7 days.

### K3s Status
```bash
./scripts/k3s-status.sh
```
Displays current state of all nodes, pods, services, disk, and memory.

### Python Monitor
```bash
python3 ./scripts/monitor.py
```
Checks all services and logs results to `scripts/monitor.log` in JSON format.

## Key Skills Demonstrated

- Kubernetes deployment and administration (k3s)
- Infrastructure as Code (Terraform)
- Container orchestration and management
- Monitoring and observability (Prometheus/Grafana)
- Linux system administration (RHEL 10)
- Bash and Python scripting
- Ansible automation
- Git version control (Gitea + GitHub mirroring)
- Network configuration and firewall management
- Self-hosted service deployment and management
