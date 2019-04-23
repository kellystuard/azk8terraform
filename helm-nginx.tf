provider "helm" {
  #version                = "~> 1.6"
  
  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
  }
}

resource "helm_release" "nginx" {
  name    = "nginx"
  chart   = "stable/nginx-ingress"
  #version = ""
  #"service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
  
  set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.k8s}"
  }
  set {
    name = "controller.replicaCount"
    value = "3"
  }
}
