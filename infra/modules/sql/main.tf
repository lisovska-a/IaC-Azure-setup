
resource "azurerm_mssql_server" "sql" {
  name                         = var.server_name
  resource_group_name          = var.rg_name
  location                     = "northeurope"
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

# Simple public access for your workstation (adjust/remove later if you’ll do private endpoint)
resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "allow-my-ip"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = var.start_ip_address
  end_ip_address   = var.end_ip_address
}

resource "azurerm_mssql_database" "db" {
  name                        = var.db_name
  server_id                   = azurerm_mssql_server.sql.id
  sku_name                    = var.sku_name              # e.g. "GP_S_Gen5_2" (General Purpose, Serverless)
  auto_pause_delay_in_minutes = var.auto_pause_delay      # e.g. 60 (use 0 to disable auto-pause)
  min_capacity                = var.min_capacity         # e.g. 0.5
  max_size_gb                 = 32
  collation                   = var.collation            # SQL_Latin1_General_CP1_CI_AS
  storage_account_type        = "Local"
}
