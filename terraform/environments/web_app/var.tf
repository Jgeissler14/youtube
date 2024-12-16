variable "tenant_id" {
  description = "The Azure Tenant ID"
  default     = "c6ac7581-7e72-4591-955d-fbb8c4dc1295"
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  default     = "8356492a-5b92-4829-95f0-48abf6418162"
}

variable "env" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "East US"
}