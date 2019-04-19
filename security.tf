provider "azuread" {
  version = "=0.1.0"
}

resource "tls_private_key" "kube_key" {
  algorithm = "RSA"
}

data "azurerm_subscription" "primary" {}

resource "azuread_application" "aks_app" {
  name = "aks_app"
  available_to_other_tenants = false
}

resource "azuread_service_principal" "aks_sp" {
  application_id = "${azuread_application.aks_app.application_id}"
}

resource "random_string" "aks_sp_password" {
  length  = 32
  special = true

  keepers = {
    service_principal = "${azuread_service_principal.aks_sp.id}"
  }
}

resource "azuread_service_principal_password" "aks_sp_password" {
  service_principal_id = "${azuread_service_principal.aks_sp.id}"
  value                = "${random_string.aks_sp_password.result}"
  end_date_relative    = "${(10 * 24 * 365)}h"

  # This stops be 'end_date' changing on each run and causing a new password to be set
  # to get the date to change here you would have to manually taint this resource...
  lifecycle {
    ignore_changes = ["end_date"]
  }
}

resource "azurerm_role_assignment" "current_contributor" {
  scope                = "${data.azurerm_subscription.primary.id}"
  role_definition_name = "Contributor"
  principal_id         = "${azuread_service_principal.aks_sp.id}"
}
