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

resource "kubernetes_namespace" "rsvp-application" {
  name = "rsvp-application"
}

resource "kubernetes_deployment" "rsvp_db" {
  metadata {
    name      = "rsvp-db"
    namespace = "rsvp-application"
  }
  spec {
    replicas = 1
    template {
      metadata {
        labels {
          appdb = "rsvpdb"
        }
      }
      spec {
        container {
          name  = "rsvpd-db"
          image = "mongo:3.3"
          port {
            container_port = 27017
          }
          env {
            name  = "MONGODB_DATABASE"
            value = "rsvpdata"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = "rsvp-application"
    labels {
      app = "rsvpdb"
    }
  }
  spec {
    port {
      protocol = "TCP"
      port     = 27017
    }
    selector {
      appdb = "rsvpdb"
    }
  }
}

resource "kubernetes_deployment" "rsvp" {
  metadata {
    name      = "rsvp"
    namespace = "rsvp-application"
  }
  spec {
    replicas = 1
    template {
      metadata {
        labels {
          app = "rsvp"
        }
      }
      spec {
        container {
          name  = "rsvp-app"
          image = "teamcloudyuga/rsvpapp"
          port {
            name           = "web-port"
            container_port = 5000
          }
          env {
            name  = "MONGODB_HOST"
            value = "mongodb"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "rsvp" {
  metadata {
    name      = "rsvp"
    namespace = "rsvp-application"
    labels {
      apps = "rsvp"
    }
  }
  spec {
    port {
      name      = "tcp-31081-5000"
      protocol  = "TCP"
      port      = 5000
      node_port = 31081
    }
    selector {
      app = "rsvp"
    }
    type = "NodePort"
  }
}
