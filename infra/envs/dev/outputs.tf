output "vnet_id" { 
    value = module.network.vnet_id
}
output "public_subnet_id" {
    value = module.network.public_subnet_id
}
output "private_subnet_id" {
    value = module.network.private_subnet_id
}
output "vmss_lb_ip" {
  value = module.vmss.lb_public_ip
}