provider "azurerm" {
   features {}
}

variable "resource_group_name" {
  description = "The name of an existing resource group to be imported."
  default     = "acctvnet"
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}
