
locals {
  poison_queue_metric_string_for_query = join("\" , \"", [for item in var.poison_queue_names : format("%s-%s", item, "length")])
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.prefix}-law"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_application_insights" "app_insights" {
  name                = "${var.prefix}-appinsights"
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  application_type    = "web"
}



resource "azurerm_application_insights_workbook" "my_workbook" {
  name                = "85b3e8bb-fc93-40be-12f2-98f6bec18ba0"
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "My Awesome Workbook"
  source_id           = lower(azurerm_application_insights.app_insights.id)
  category            = "workbook"
  data_json           = jsonencode(templatefile("${path.module}/workbook.json", { ai_source_id = lower(azurerm_application_insights.app_insights.id), law_source_id = lower(azurerm_log_analytics_workspace.log_analytics.id) }))
}


resource "azurerm_monitor_scheduled_query_rules_alert_v2" "poison_queue_alert" {
  name                = "Poison queue alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.app_insights.id]
  description         = "Alerting if there is a message in a poison queue."
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  severity             = 1
  criteria {
    query = <<-QUERY
      customMetrics
        | where name in ("${local.poison_queue_metric_string_for_query}")
        | summarize merticValue = avg(value) by name, bin(timestamp, 5m)
 
      QUERY

    time_aggregation_method = "Average"
    threshold               = 0
    operator                = "GreaterThan"
    metric_measure_column   = "merticValue"

    dimension {
      name     = "name" # creating timeseries for each poisen queue
      operator = "Include"
      values   = ["*"]
    }
  }

  auto_mitigation_enabled = true

}
 