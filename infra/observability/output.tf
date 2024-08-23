output "appinsights_connection_string" {
  value = azurerm_application_insights.app_insights.instrumentation_key
}
