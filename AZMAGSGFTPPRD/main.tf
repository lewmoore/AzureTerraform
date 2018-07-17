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
  resource_group_name = "${azurerm_resource_group.ftpprdrg.name}"

  ip_configuration {
    name = "AZMAGNIC12-ip"
    subnet_id = "${azurerm_subnet.snet12.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "10.0.1.4"
    public_ip_address_id = "${azurerm_public_ip.prdpip.id}"
  }
}

resource "azurerm_public_ip" "prdpip" {
  name = "AZMAGPIPFTPPRD"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.ftpprdrg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_virtual_machine" "FTPPRD-vm" {
  name = "AZMAGVMCFTPPRD"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.ftpprdrg.name}"
  network_interface_ids = ["${azurerm_network_interface.prdnic.id}"]
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
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {

  }
}
