output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.this.id
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}

output "lb_id" {
  value = azurerm_lb.lb.id
}