module "network" {
  source   = "../../modules/network"
  rg_name  = var.rg_name
  location = var.location

  # Addressing per task
  vnet_cidr          = var.vnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr= var.private_subnet_cidr
}
