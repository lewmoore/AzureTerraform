provider "azurerm" {
subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "kafuatrg" {
        name = "AZMAGRGKAFUAT"
        location = "${var.location}"
}

resource "azurerm_resource_group" "vnet2rg" {
  name = "AZMAGRGVNET2"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet2" {
  name = "AZMAGVNET2"
  resource_group_name = "${azurerm_resource_group.vnet2rg.name}"
  address_space = ["172.168.0.0/16"]
  location = "${var.location}"
}

resource "azurerm_subnet" "snet21" {
  name = "AZMAGSNET21"
  resource_group_name = "${azurerm_resource_group.vnet2rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet2.name}"
  address_prefix = "172.168.0.0/16"
}
