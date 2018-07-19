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

resource "azurerm_network_interface" "kafuatnic" {
  name = "AZMAGNIC21"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.kafuatrg.name}"

  ip_configuration {
    name = "AZMAGNIC21-ip"
    subnet_id = "${azurerm_subnet.snet21.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "172.168.0.4"
    public_ip_address_id = "${azurerm_public_ip.kafuatpip.id}"
  }
}

resource "azurerm_public_ip" "kafuatpip" {
  name = "AZMAGPIPKAFUAT"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.kafuatrg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_virtual_machine" "KAFUAT-vm" {
  name = "AZMAGVMCKAFUAT"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.kafuatrg.name}"
  network_interface_ids = ["${azurerm_network_interface.kafuatnic.id}"]
  vm_size = "Standard_DS1_v2"

  storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }
   storage_os_disk {
    name              = "${azurerm_resource_group.kafuatrg.name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
    os_profile {
    computer_name  = "hostname"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        path     = "/home/testadmin/.ssh/authorized_keys"
        key_data = "${var.public_ssh_key}"
    }
  }
}
