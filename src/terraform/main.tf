resource "azurerm_resource_group" "example" {
  name     = "Resource_3"
  location = "Central India"
}


resource "azurerm_storage_account" "example" {
  name                     = "storage3242345692"
  resource_group_name      = "Resource_3"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [
    azurerm_resource_group.example
  ]

}

resource "azurerm_storage_container" "example" {
  name                  = "tfstate"
  storage_account_name  = "storage3242345692"
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.example
  ]
}