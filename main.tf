# Create a resource group
resource "azurerm_resource_group" "this" {
  name     = "yt-demo"
  location = "East US"
}

resource "azurerm_storage_account" "this" {
  name                          = "demostrgyt"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = var.public_network_access_enabled
}

resource "azurerm_storage_container" "this" {
  name                  = "demo-blob"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "demo-msi-yt"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

//data factory
resource "azurerm_data_factory" "this" {
  name                            = "demo-adf-yt"
  location                        = azurerm_resource_group.this.location
  resource_group_name             = azurerm_resource_group.this.name
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
  target_resource_id = azurerm_storage_account.this.id
  subresource_name   = "blob"
}

resource "azurerm_data_factory_integration_runtime_azure" "this" {
  data_factory_id = azurerm_data_factory.this.id
  name           = "demo-adf-ir-yt"
  virtual_network_enabled = true
  location = "AutoResolve"
}

resource "azurerm_data_factory_credential_user_managed_identity" "this" {
  data_factory_id = azurerm_data_factory.this.id
  name            = "demo-adf-cred-yt"
  identity_id     = azurerm_user_assigned_identity.this.id
}

resource "azurem_role_assignment" "this" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "this" {
  data_factory_id = azurerm_data_factory.this.id
  name           = "demo-adf-ls-yt"
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.this.name
  connection_string = azurerm_storage_account.this.primary_blob_connection_string
  use_managed_identity = true
  
}