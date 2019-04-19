resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "azk8terraform"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "azk8terraform-${var.environment}"
  kubernetes_version  = "1.11.9"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      // TODO: Move in to KeyVault, along with private key
      key_data = "${chomp(tls_private_key.kube_key.public_key_openssh)}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "3"
    vm_size         = "Standard_B2S"
    os_type         = "Linux"
    // allowed range: 30-1024
    os_disk_size_gb = 30
  }
  
  service_principal {
    client_id     = "${azuread_application.aks_app.application_id}"
    client_secret = "${random_string.aks_sp_password.result}"
  }
  
  tags {
    Environment = "${var.environment}"
  }
}
