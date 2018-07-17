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
