resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "azk8terraform"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

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
    os_disk_size_gb = 5
  }
  
  service_principal {
    client_id     = // put here from security.tf
    client_secret = // put here from security.tf
  }
  
  tags {
    Environment = "${var.environment}"
  }
}
