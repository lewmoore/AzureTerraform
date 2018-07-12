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

resource "azurerm_virtual_machine" "FTPUAT-vm" {
  name = "AZMAGVMCFTPUAT"
  location = "North Europe"
  resource_group_name = "${azurerm_resource_group.machinerg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size = "Standard_DS1_v2"

  storage_image_reference {
   publisher = "MicrosoftWindowsServer"
   offer     = "WindowsServer"
   sku       = "2016-Datacenter"
   version   = "latest"
 }
   storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
    os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {

  }
}
