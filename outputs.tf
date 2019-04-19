output "kube_config" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

output "k8s_rsvp_ip" {
  value = "${azurerm_public_ip.k8s_rsvp}"
}
