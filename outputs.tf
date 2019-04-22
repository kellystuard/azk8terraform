output "kube_config" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

output "k8s_nginx" {
  value = "${kubernetes_service.nginx.load_balancer_ingress}"
}
