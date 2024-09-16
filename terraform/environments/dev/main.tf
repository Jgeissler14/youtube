locals {
  resource_group_name = "${var.env}-rg-yt"
}
# Create a resource group
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = "East US"
}

resource "azurerm_storage_account" "this" {
  name                          = "${var.env}strgtest"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = var.public_network_access_enabled
}

resource "azurerm_storage_container" "this" {
  name                  = "${var.env}-blob"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

module "adf" {
  source                            = "../../modules/datafactory"
  public_network_access_enabled     = var.public_network_access_enabled
  resource_group_name               = azurerm_resource_group.this.name
  location                          = azurerm_resource_group.this.location
  stroage_account_id                = azurerm_storage_account.this.id
  stroage_account_connection_string = azurerm_storage_account.this.primary_blob_connection_string
}