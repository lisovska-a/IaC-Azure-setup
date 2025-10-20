variable "rg_name" {
    type = string
}
variable "location" {
    type = string
}
variable "admin_username" {
    type = string
}
variable "ssh_public_key" {
    type = string
}
variable "public_subnet_id" {
    type = string
}
variable "admin_password" {
    type = string
    sensitive = true
}