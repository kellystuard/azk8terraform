# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.k8s.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.k8s.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.k8s.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.k8s.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.k8s.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.k8s.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.k8s.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "gateway-${local.environment}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  location            = "${azurerm_resource_group.k8s.location}"

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 3
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = "${azurerm_subnet.appgwsubnet.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.k8s.id}"
  }

  backend_address_pool {
    name         = "${local.backend_address_pool_name}"
    ip_addresses = ["${local.azurerm_subnet_k8s-ingress_ip_address}"]
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }
  
  tags = {
    environment = "${local.environment}"
  }
}
