resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "public" {
  name                 = var.pub_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_cidr]
}

# A public IP for NAT
resource "azurerm_public_ip" "natgw_pip" {
  name                = "pip-natgw"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "natgw" {
  name                = "natgw-public"
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw_pip.id
}

# Attach NAT GW to the subnet that hosts the VMSS
resource "azurerm_subnet_nat_gateway_association" "public_subnet_nat" {
  subnet_id      = azurerm_subnet.public.id        
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}


resource "azurerm_subnet" "private" {
  name                 = var.priv_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}
