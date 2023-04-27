terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }



}

provider "azurerm" {
# Configuration options
subscription_id = "6498feeb-1a03-4d38-a1cf-2f21346ef871"
tenant_id = "e2998842-9287-4ca9-bfc6-09d7d5aa8407"
client_id = "50f0c2a9-3ed5-4c8e-97af-7100c39b6811"
client_secret = "y9F8Q~uARShtpTHHhiKCOS4NfPrvM~hvoQKSHbI2"
 features {}
}
resource "azurerm_resource_group" "example" {
  name     = "Resource_2"
  location = "Central India"
}



resource "azurerm_storage_account" "example" {
  name                     = "storage3242345678"
  resource_group_name      = "Resource_1"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_account" "example1" {
  name                     = "storage3242345679"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}




resource "azurerm_virtual_network" "main" {
  name                = "safe-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "main" {
  name                = "safe-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_public_ip" "example" {
  name                    = "test-pip"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Static"
  depends_on = [ azurerm_resource_group.example ]
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    
  }
  depends_on = [ azurerm_resource_group.example ]
}


resource "azurerm_windows_virtual_machine" "example" {
  name                = "firstmachine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
resource "azurerm_managed_disk" "example" {
  name                 = "acctestmd"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_windows_virtual_machine.example.id
  lun                = "0"
  caching            = "ReadWrite"
}