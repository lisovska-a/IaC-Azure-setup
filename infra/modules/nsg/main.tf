# Public NSG - allows SSH only from any IP
resource "azurerm_network_security_group" "public" {
  name                = "nsg-snet-public"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                        = "Allow-SSH-From-Own-IP"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = var.my_public_ip_cidr
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "Allow-Access-from-port-80"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = var.my_public_ip_cidr
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "Allow-Outbound-Internet"
    priority                    = 200
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "Internet"
  }
}


# Private NSG - allow internal access from public subnet only
resource "azurerm_network_security_group" "private" {
  name                = "nsg-snet-private"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
      name                        = "Allow-From-Public-Subnet"
      priority                    = 100
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "10.0.0.0/17"
      destination_address_prefix  = "*"
  }
}

# Attach NSGs to subnets
resource "azurerm_subnet_network_security_group_association" "public_assoc" {
  subnet_id                 = var.public_subnet_id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  subnet_id                 = var.private_subnet_id
  network_security_group_id = azurerm_network_security_group.private.id
}
