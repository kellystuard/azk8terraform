data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "current_contributor" {
  scope                = "${data.azurerm_subscription.primary.id}"
  role_definition_name = "Contributor"
  principal_id         = "${data.azurerm_client_config.test.service_principal_object_id}"
}
