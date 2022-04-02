resource "azurerm_resource_group" "ansible" {
  name     = "${var.TFPrefix}ansible-resources"
  location = var.location
}

resource "azurerm_public_ip" "ansiblePip" {
  name                = "${var.TFPrefix}myPublicIP"
  location            = azurerm_resource_group.ansible.location
  resource_group_name = azurerm_resource_group.ansible.name
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet" "ansible" {
  name                 = "${var.TFPrefix}ansible-subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_interface" "ansible" {
  name                = "${var.TFPrefix}-ansible-nic"
  location            = azurerm_resource_group.ansible.location
  resource_group_name = azurerm_resource_group.ansible.name

  ip_configuration {
    name                          = "ansibleNicConfiguration"
    subnet_id                     = azurerm_subnet.ansible.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansiblePip.id
  }
}

resource "azurerm_network_security_group" "ansible-nsg" {
  name                = "${var.TFPrefix}ansible-nsg"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location

  security_rule {
    name                       = "blockAll"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    direction                  = "Inbound"
    priority                   = 100
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.my_ip
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "ansible" {
  subnet_id                 = azurerm_subnet.ansible.id
  network_security_group_id = azurerm_network_security_group.ansible-nsg.id
}

resource "azurerm_linux_virtual_machine" "ansible" {
  name                  = "${var.TFPrefix}ansibleVM"
  location              = azurerm_resource_group.ansible.location
  resource_group_name   = azurerm_resource_group.ansible.name
  network_interface_ids = [azurerm_network_interface.ansible.id]
  size                  = "Standard_B1ls"
  admin_username        = var.ansible_username
  admin_password        = var.ansible_password
  disable_password_authentication = false

  os_disk {
    caching       = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}