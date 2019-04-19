output "kube_config" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

output "k8s_rsvp" {
  value = "${kubernetes_service.rsvp.load_balancer_ingress}"
}
