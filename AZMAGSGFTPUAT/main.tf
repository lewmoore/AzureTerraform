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
}

resource "azurerm_subnet" "snet11" {
  name = "AZMAGSNET11"
  address_prefix = "10.0.0.0/24"
  resource_group_name = "${azurerm_resource_group.vnet1rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
}

resource "azurerm_public_ip" "pip1" {
  name = "AZMAGPIPFTPUAT"
  location = "North Europe"
  resource_group_name = "${azurerm_resource_group.machinerg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "nic" {
  name = "AZMAGNIC11"
  location = "North Europe"
  resource_group_name = "${azurerm_resource_group.machinerg.name}"
  network_security_group_id = "${azurerm_network_security_group.ftpuat-sg.id}"

  ip_configuration {
    name = "AZMAGNIC11_ip"
    subnet_id = "${azurerm_subnet.snet11.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "10.0.0.4"
    public_ip_address_id = "${azurerm_public_ip.pip1.id}"
  }
}
