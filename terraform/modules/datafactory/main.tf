resource "azurerm_user_assigned_identity" "this" {
  name                = "demo-msi-yt"
  location            = var.location
  resource_group_name = var.resource_group_name
}

//data factory
resource "azurerm_data_factory" "this" {
  name                            = "demo-adf-yt"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  managed_virtual_network_enabled = true

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "this" {
  data_factory_id    = azurerm_data_factory.this.id
  name               = "demo-adf-pe-yt"
  target_resource_id = var.stroage_account_id
  subresource_name   = "blob"
}

resource "azurerm_data_factory_integration_runtime_azure" "this" {
  data_factory_id         = azurerm_data_factory.this.id
  name                    = "demo-adf-ir-yt"
  virtual_network_enabled = true
  location                = "AutoResolve"
}

resource "azurerm_data_factory_credential_user_managed_identity" "this" {
  data_factory_id = azurerm_data_factory.this.id
  name            = "demo-adf-cred-yt"
  identity_id     = azurerm_user_assigned_identity.this.id
}

resource "azurerm_role_assignment" "this" {
  scope                = var.stroage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "this" {
  data_factory_id          = azurerm_data_factory.this.id
  name                     = "demo-adf-ls-yt"
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.this.name
  connection_string        = var.stroage_account_connection_string
  use_managed_identity     = true

}