


resource "azurerm_storage_account" "stoarge_account" {
  name                     = "${var.prefix}sa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_service_plan" "azurerm_service_plan" {
  name                = "${var.prefix}-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "EP1"
  maximum_elastic_worker_count        = 1
}

resource "azurerm_user_assigned_identity" "mi_function_app" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "example"
}

resource "azurerm_linux_function_app" "orchestrator_function_app" {
  name                          = "${var.prefix}-function-app"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.azurerm_service_plan.id
  https_only                    = true
  public_network_access_enabled = true


  storage_account_name       = azurerm_storage_account.stoarge_account.name
  storage_account_access_key = azurerm_storage_account.stoarge_account.primary_access_key

  # Recommended to deactivate builtin logging
  # https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#disable-built-in-logging
  builtin_logging_enabled = false


  app_settings = {
    AzureWebJobsDisableHomepage         = true
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    WEBSITE_PULL_IMAGE_OVER_VNET        = true
    PYTHON_ENABLE_WORKER_EXTENSIONS     = 1
    DURABLE_TASK_HUB_NAME               = "TESTHUB"
    MONITORED_QUEUES                    = jsonencode(var.monitoring_queue_name)
  }
  identity {
    type = "SystemAssigned"
  }
  sticky_settings {
    app_setting_names = ["DURABLE_TASK_HUB_NAME", "AzureWebJobs.process_aml_event.Disabled"]
  }

  site_config {
    minimum_tls_version                    = "1.2"
    http2_enabled                          = true
    application_insights_connection_string = var.appinsight_connection_string
    app_service_logs {
      disk_quota_mb         = 35
      retention_period_days = 7
    }

    application_stack {
      docker {
        registry_url      = var.registry_url
        registry_username = var.registry_username
        registry_password = var.registry_password
        image_name        = var.image_name
        image_tag         = var.image_tag

      }
    }
  }
}

resource "azurerm_role_assignment" "stoarge_account_role_assignment" {
  scope                = var.storage_account_name_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.orchestrator_function_app.identity[0].principal_id
}
