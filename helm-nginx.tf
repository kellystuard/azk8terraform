provider "helm" {
  #version                = "~> 1.6"
  
  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
  }
}

data "helm_release" "nginx" {
  name    = "nginx"
  chart   = "stable/nginx-ingress"
  #version = ""
  #"service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
  
  set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.k8s.ip_address}"
  }
  set {
    name = "controller.replicaCount"
    value = "3"
  }
}

data "helm_repository" "azure-samples" {
    name = "azure-samples"
    url  = "https://azure-samples.github.io/helm-charts/"
}

data "helm_release" "aks-helloworld" {
    name       = "aks-helloworld"
    repository = "${data.helm_repository.azure-samples.metadata.0.name}"
    chart      = "aks-helloworld"
}
