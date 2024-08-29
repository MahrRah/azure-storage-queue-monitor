output "acr_url" {
  value = azurerm_container_registry.acr.login_server
}

output "app_insights_connection_string" {
  value     = module.observability.appinsights_connection_string
  sensitive = true
}
