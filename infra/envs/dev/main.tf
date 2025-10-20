module "network" {
  source   = "../../modules/network"
  rg_name  = var.rg_name
  location = var.location

  # Addressing per task
  vnet_cidr          = var.vnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr= var.private_subnet_cidr
}

module "nsg" {
  source           = "../../modules/nsg"
  rg_name          = var.rg_name
  location         = var.location
  my_public_ip_cidr= var.my_public_ip_cidr

  public_subnet_id = module.network.public_subnet_id
  private_subnet_id= module.network.private_subnet_id
}

# module "vmss" {
#   source          = "../../modules/vmss"
#   rg_name          = var.rg_name
#   location         = var.location
#   admin_username   = var.admin_username
#   ssh_public_key   = var.ssh_public_key
#   public_subnet_id = module.network.public_subnet_id

#   depends_on = [module.network, module.nsg]
# }

# module "vm" {
#   source            = "../../modules/vm"
#   rg_name           = var.rg_name
#   location          = var.location
#   admin_username    = var.admin_username
#   ssh_public_key    = var.ssh_public_key
#   private_subnet_id = module.network.private_subnet_id
# }

# module "autoscale_vmss" {
#   source   = "../../modules/vmss_autoscale"
#   rg_name  = var.rg_name
#   location = var.location
#   vmss_id  = module.vmss.vmss_id

#   depends_on = [module.vmss]
  
# }

module "storage" {
  source          = "../../modules/storage"
  rg_name          = var.rg_name
  location         = var.location
  admin_username   = var.admin_username
  ssh_public_key   = var.ssh_public_key
  public_subnet_id = module.network.public_subnet_id
  admin_password   = var.admin_password

  depends_on = [module.network, module.nsg]
  
}

module "sql" {
  source          = "../../modules/sql"
  rg_name         = var.rg_name
  location        = var.location
  admin_username  = var.admin_username
  admin_password  = var.admin_password
  public_subnet_id = module.network.public_subnet_id
  start_ip_address = var.start_ip_address
  end_ip_address   = var.end_ip_address

  depends_on = [module.network, module.nsg]
}