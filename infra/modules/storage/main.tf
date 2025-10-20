resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-public"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_public_ip" "vm_pip" {
  name                = "pip-vm-public"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "vm-public"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

   os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}


resource "azurerm_public_ip" "win_pip" {
  name                = "pip-vm-windows"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "win_nic" {
  name                = "nic-vm-windows"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipcfg"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "win" {
  name                = "vm-windows"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.win_nic.id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  enable_automatic_updates = true
}
