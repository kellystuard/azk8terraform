provider "kubernetes" {
  version                = "~> 1.6"
  
  host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
}

provider "tls" {
  version = "~> 2.0"
}

resource "kubernetes_namespace" "nginx-application" {
  metadata {
    name = "nginx-application"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "nginx-application"
    labels {
      app = "nginx"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx-app"
          image = "nginx:1.15-alpine"
          port {
            name           = "web-port"
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "nginx-application"
    labels {
      apps = "nginx"
    }
    annotations {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
  }
  spec {
    type             = "LoadBalancer"
    port {
      name        = "tcp-80-80"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
    selector {
      app = "nginx"
    }
  }
}
