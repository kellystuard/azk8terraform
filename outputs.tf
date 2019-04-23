output "public_ip" {
  value = "${azurerm_public_ip.k8s.ip_address}"
}
output "kube_config" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}
