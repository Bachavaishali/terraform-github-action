terraform {
  backend "azurerm" {
    resource_group_name  = "Resource_1"
    storage_account_name = "storage3242345678"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}