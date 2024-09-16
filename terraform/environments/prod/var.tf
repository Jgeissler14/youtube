variable "tenant_id" {
  description = "The Azure Tenant ID"
  default     = "c6ac7581-7e72-4591-955d-fbb8c4dc1295"
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  default     = "d5f8ed7f-6d25-46f4-a1dc-abc929a2fcda"
}

variable "env" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the storage account"
  default     = true
}