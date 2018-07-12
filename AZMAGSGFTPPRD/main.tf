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
