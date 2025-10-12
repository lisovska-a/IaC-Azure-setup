variable "rg_name"  { type = string }
variable "location" { type = string }

variable "vnet_cidr"           { type = string }
variable "public_subnet_cidr"  { type = string }
variable "private_subnet_cidr" { type = string }

variable "vnet_name"  { 
    type = string  
    default = "vnet-nebo" 
}
variable "pub_name"   { 
    type = string  
    default = "snet-public" 
}
variable "priv_name"  { 
    type = string  
    default = "snet-private" 
}
variable "tags"       { 
    type = map(string) 
    default = {} 
}