variable "location" {
   type = string
}
variable "rg_name" {
   type = string
}
variable "my_public_ip_cidr" {
   type = string
}
variable "vnet_cidr" {
   type = string
}
variable "public_subnet_cidr" {
   type = string
}
variable "private_subnet_cidr" {
   type = string
}
variable "tags" {
  type    = map(string)
  default = { project = "nebo", env = "dev" }
}
variable "admin_username" {
   type = string
}
variable "ssh_public_key" {
   type = string
}
