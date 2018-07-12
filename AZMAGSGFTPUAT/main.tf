provider "azurerm" {
subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "machinerg" {
        name = "AZMAGRGFTPUAT"
        location = "north europe"
}

resource "azurerm_resource_group" "vnet1rg" {
  name = "AZMAGRGVNET1"
  location = "North Europe"
}

resource "azurerm_virtual_network" "vnet1" {
  resource_group_name = "${azurerm_resource_group.vnet1rg.name}"
  name = "AZMAGVNET1"
  address_space = ["10.0.0.0/23"]
  location = "North Europe"

  subnet {
    name = "AZMAGSNET11"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name = "AZMAGSNET12"
    address_prefix = "10.0.1.0/24"
  }
}
