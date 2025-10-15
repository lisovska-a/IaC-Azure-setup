# Public LB, backend pool (if not already created upstream)
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-vmss-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "lb-vmss"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-fe"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_nat_pool" "ssh" {
  name                           = "ssh-nat-pool"
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "public-fe"

  frontend_port_start = 50000
  frontend_port_end   = 50019   # supports up to 20 instances; adjust as needed
  backend_port        = 22
}

resource "azurerm_lb_backend_address_pool" "be_pool" {
  name                = "lb-be-pool"
  loadbalancer_id     = azurerm_lb.lb.id
}

# Health probe for 80
resource "azurerm_lb_probe" "http" {
  name            = "http-probe-80"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http" {
  name                           = "http-rule-80"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public-fe"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.be_pool.id]
  probe_id                       = azurerm_lb_probe.http.id

}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "vmss-web"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard_B2s"
  instances           = 2
  admin_username      = var.admin_username

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  upgrade_mode = "Automatic"

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  network_interface {
    name    = "nic"
    primary = true
    ip_configuration {
      name      = "ipcfg"
      primary   = true
      subnet_id = var.public_subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.be_pool.id]
      
      load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.ssh.id]
    }
  }

  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))


}
