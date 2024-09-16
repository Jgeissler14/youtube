variable "tenant_id" {
  description = "The Azure Tenant ID"
  default     = "c6ac7581-7e72-4591-955d-fbb8c4dc1295"
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  default     = "d5f8ed7f-6d25-46f4-a1dc-abc929a2fcda"
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the storage account"
  default     = true
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "stroage_account_id" {
  description = "The id of the storage account"
  type        = string
}

variable "stroage_account_connection_string" {
  description = "The connection string of the storage account"
  type        = string
}
