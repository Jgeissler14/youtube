locals {
  resource_group_name = "${var.env}-rg-yt"
}
# Create a resource group
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "this" {
  name                = "ASP-devrgyt-bcb8"
  resource_group_name = azurerm_resource_group.this.name
  location            = "canadacentral" //azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_app_service" "this" {
  name                = "dev-web-app-yt"
  location            = "canadacentral" //azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = azurerm_service_plan.this.id

  https_only = true

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
