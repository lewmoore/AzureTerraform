provider "azurerm" {
subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "rg" {
        name = "AZMAGRGFTPUAT"
        location = "north europe"
}
