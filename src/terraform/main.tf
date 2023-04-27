terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }
}
backend "azurerm" {
    resource_group_name = "friday-demo-rg"
    strorage_account_name = "akhdcjjsjc"
    container_name = "tfstate"
    key = "dev.terraform.tfstate"
}


provider "azurerm" {
  # Configuration options
 # subscription_id = "6498feeb-1a03-4d38-a1cf-2f21346ef871"
# tenant_id = "e2998842-9287-4ca9-bfc6-09d7d5aa8407"
 # client_id = "50f0c2a9-3ed5-4c8e-97af-7100c39b6811"
  #client_secret = var.client_secret
  features {}
}
resource "azurerm_resource_group" "example" {
  name     = "Resource_1"
  location = "Central India"
}