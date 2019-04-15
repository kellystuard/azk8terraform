provider "terraform" {
  version = "=0.11.13"
}
provider "azurerm" {
  version = "=1.24.0"
}
resource "azurerm_resource_group" "k8s" {
  name     = "k8s"
  location = "Central US"
  
  tags = {
    environment = "var.environment"
  }
}
