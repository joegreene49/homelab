terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_deployment" "uptime_kuma" {
  metadata {
    name      = "uptime-kuma"
    namespace = "default"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "uptime-kuma"
      }
    }
    template {
      metadata {
        labels = {
          app = "uptime-kuma"
        }
      }
      spec {
        container {
          name  = "uptime-kuma"
          image = "louislam/uptime-kuma:latest"
          port {
            container_port = 3001
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "uptime_kuma" {
  metadata {
    name      = "uptime-kuma"
    namespace = "default"
  }
  spec {
    selector = {
      app = "uptime-kuma"
    }
    type = "NodePort"
    port {
      port        = 3001
      target_port = 3001
      node_port   = 30301
    }
  }
}
