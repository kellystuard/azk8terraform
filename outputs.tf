output "kube_config" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

output "k8s_rsvp_ip" {
  value = "${kubernetes_service.rsvp.load_balancer_ingress.ip}"
}
output "k8s_rsvp_hostname" {
  value = "${kubernetes_service.rsvp.load_balancer_ingress.hostname}"
}
