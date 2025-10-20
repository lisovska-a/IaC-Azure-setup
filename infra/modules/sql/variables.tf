variable "server_name" {
    type = string
    default = "sql-server-nebo-ne"
}
variable "rg_name" {
    type = string
}
variable "location" {
    type = string
}
variable "admin_username" {
    type = string
}
variable "admin_password" {
    type = string
}
variable "public_subnet_id" {
    type = string
}
variable "tags" {
    type    = map(string)
    default = { project = "nebo" }
}
variable "start_ip_address" {
    type = string
}
variable "end_ip_address" {
    type = string
}
variable "db_name" {
    type    = string
    default = "Bike Stores"
}
variable "sku_name" {
    type    = string
    default = "GP_S_Gen5_2"
}
variable "collation" {
    type    = string
    default = "SQL_Latin1_General_CP1_CI_AS"
}
variable "min_capacity" {
    type    = number
    default = 0.5
}
variable "auto_pause_delay" {
    type    = number
    default = 60
}