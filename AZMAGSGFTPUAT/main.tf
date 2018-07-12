provider "azurerm" {
subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "machinerg" {
        name = "AZMAGRGFTPUAT"
        location = "north europe"
}

resource "azurerm_resource_group" "vnetrg" {
  name = "AZMAGRGVNET1"
  location = "North Europe"
}

resource "azurerm_virtual_network" "vnet1" {
  name = "AZMAGVNET1"
  address_space = ["10.0.0.0/23"]
  location = "North Europe"
  resource_group_name = "AZMAGRGVNET1"
}
