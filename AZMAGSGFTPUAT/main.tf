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
