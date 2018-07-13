data "terraform_remote_state" "localstate" {
  backend = "local"

  config {
    path = "../AZMAGSGFTPUAT/terraform.tfstate"
  }
}

provider "azurerm" {
subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "ftpprdrg" {
        name = "AZMAGRGFTPPRD"
        location = "${var.location}"
}

resource "azurerm_subnet" "snet12" {
  name = "AZMAGSNET12"
  address_prefix = "10.0.1.0/24"
  resource_group_name = "${data.terraform_remote_state.localstate.azurerm_resource_group_name}"
  virtual_network_name = "${data.terraform_remote_state.localstate.virtual_network_name}"
}

resource "azurerm_network_interface" "prdnic" {
  name = "AZMAGNIC12"
  location = "${var.location}"
  resource_group_name = "${data.terraform_remote_state.localstate.azurerm_resource_group_name}"

  ip_configuration {
    name = "AZMAGNIC12-ip"
    subnet_id = "${azurerm_subnet.snet12.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "10.0.1.4"
  }
}
