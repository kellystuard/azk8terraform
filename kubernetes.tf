resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "azk8terraform"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      // TODO: Move in to KeyVault, along with private key
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjyf3z+OTor+tvTPguxcAd9zvxQNctsrx2FYXbdI1nD/g7HgZk+Q2XoJ0WYzlZg4dOA8DfZKAw9Vvhm2KnGrsoCQa+nv47Vwwq1bC8GAJ6vQ3VYEOcyLrt54Soo6J907DXmFjFdXpKEMPHnobitOhHk7DiH7+AUWK95TaTHkLtQnKGKbRo0Lv+GHKpcTbWhPj7eCGlPg0rKuRfx995379tXtaenR5oS8HQpcPqR99fx6drmd0FD5P2fgjN0H1wrEQoPsTG+4Lp2w9Wfs37LQpnObGWcpSgbaMdNYBv4/1mzlBPPtjlmFyNWjcXb8nmcICbcWyp57VbBzeXx8ydpYSmw== azure
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
