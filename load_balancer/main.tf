resource "azurerm_public_ip" "LB-PIP" {
  name                = "${var.TFPrefix}LB-PIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = var.sku
}

resource "azurerm_lb" "LB" {
  name                = "${var.TFPrefix}LB"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = "lb_IPAddress"
    public_ip_address_id = azurerm_public_ip.LB-PIP.id
  }
}
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.LB.id
  name            = "${var.TFPrefix}BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "backend-pool-association" {
  count                   = var.vmcount
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(var.client-vms.nic.*.id, count.index)
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "${var.TFPrefix}LBRule"
  protocol                       = "TCP"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_lb.LB.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}
resource "azurerm_lb_probe" "probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.LB.id
  name                = "http-port8080-running-probe"
  protocol            = "HTTP"
  port                = 8080
  request_path        = "/"
}
