resource "azurerm_resource_group" "example" {
  name     = "Resource_1"
  location = "Central India"
}


resource "azurerm_storage_account" "example" {
  name                     = "storage3242345678"
  resource_group_name      = "Resource_1"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "example" {
  name                  = "tfstate"
  storage_account_name  = storage3242345678
  container_access_type = "private"
}