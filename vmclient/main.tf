resource "azurerm_network_interface" "NIC" {
  count               = var.vmcount
  name                = "nic${count.index + 1 }"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "client-vm" {
  count                           = var.vmcount
  name                            = "vm${count.index + 1}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = [azurerm_network_interface.NIC[count.index].id]
  zone                            = element(var.zones, count.index)
  

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "${var.TFPrefix}"
    vm          = "vm${count.index + 1}"
  }
}