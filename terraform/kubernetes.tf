resource "azurerm_kubernetes_cluster" "k8s_ingress" {
  name                = "kubernetes-${var.environment}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "azk8-ingress-${var.environment}"
  kubernetes_version  = "1.11.9"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      #TODO: Move in to KeyVault, along with private key
      key_data = "${chomp(tls_private_key.kube_key.public_key_openssh)}"
    }
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "3"
    vm_size         = "Standard_B2s"
    os_type         = "Linux"
    #allowed range: 30-1024
    os_disk_size_gb = 30
    vnet_subnet_id  = "${azurerm_subnet.k8s_ingress.id}"
  }
  
  service_principal {
    client_id     = "${azuread_application.aks_app.application_id}"
    client_secret = "${random_string.aks_sp_password.result}"
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }

  tags {
    environment = "${var.environment}"
  }
}
