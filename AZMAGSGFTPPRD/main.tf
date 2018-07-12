provider "azurerm" {
subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "ftpprdrg" {
        name = "AZMAGRGFTPPRD"
        location = "${var.location}"
}
