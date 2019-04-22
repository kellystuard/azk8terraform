terraform {
  required_version = "=0.11.13"
}

provider "random" {
  version = "~> 2.1"
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

resource "azurerm_virtual_network" "k8s" {
  name                = "k8s"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  address_space       = ["15.0.0.0/8"]
}

resource "azurerm_subnet" "kubesubnet" {
  name                 = "kubesubnet"
  virtual_network_name = "${azurerm_virtual_network.k8s.name}"
  resource_group_name  = "${azurerm_resource_group.k8s.name}"
  address_prefix       = "15.0.0.0/16" 
}

resource "azurerm_subnet" "appgwsubnet" {
  name                 = "appgwsubnet"
  virtual_network_name = "${azurerm_virtual_network.k8s.name}"
  resource_group_name  = "${azurerm_resource_group.k8s.name}"
  address_prefix       = "15.1.0.0/16"
}

resource "azurerm_public_ip" "k8s" {
  name                = "k8s"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  sku                 = "Basic"
  allocation_method   = "Dynamic"
}
