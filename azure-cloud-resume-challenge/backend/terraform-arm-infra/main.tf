terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.57.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rgcrctopcug"
    storage_account_name = "stcrctopcug"
    container_name       = "stcinfra"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
}
#Create Storage account
resource "azurerm_storage_account" "st" {
  name                     = var.st
  resource_group_name      = var.rg
  location                 = var.location
  min_tls_version          = "TLS1_2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}
resource "azurerm_storage_container" "stc" {
  name                  = var.stc
  storage_account_name  = var.st
  container_access_type = "private"
}

locals {
  cwd                = path.cwd
  module             = path.module
  root               = path.root
  mime_types         = jsondecode(file("${path.module}/mime.json"))
  name               = "slack-notification"
  resource_location  = "East Us 2"
  logic_app_sku      = "Standard"
  slack_channel_name = "logic-terraform"
}
output "cwd" { value = local.cwd }
output "root" { value = local.root }
output "module" { value = local.module }

data "archive_file" "file_func" {
  type        = "zip"
  source_dir  = "../backend/api"
  output_path = "../backend/api/func.zip"
}

resource "azurerm_application_insights" "appi" {
  name                = var.appi
  location            = var.location
  resource_group_name = var.rg
  application_type    = "other"
}
output "instrumentation_key" {
  value     = azurerm_application_insights.appi.instrumentation_key
  sensitive = true
}
output "app_id" {
  value     = azurerm_application_insights.appi.app_id
  sensitive = true
}
resource "azurerm_cosmosdb_account" "cosmos" {
  name                               = var.cosmos
  location                           = var.location
  resource_group_name                = var.rg
  offer_type                         = "Standard"
  enable_free_tier                   = true
  access_key_metadata_writes_enabled = false
  kind                               = "GlobalDocumentDB"
  enable_automatic_failover          = false
  capabilities {
    name = "EnableServerless"
  }

  capabilities {
    name = "EnableTable"
  }
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
}

resource "azurerm_service_plan" "asp" {
  name                = var.asp
  resource_group_name = var.rg
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = var.func
  resource_group_name        = var.rg
  location                   = var.location
  storage_account_name       = azurerm_storage_account.st.name
  storage_account_access_key = azurerm_storage_account.st.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id
  zip_deploy_file            = "../backend/api/func.zip"


  app_settings = {
    ENABLE_ORYX_BUILD              = "true"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    connectionString               = "DefaultEndpointsProtocol=https;AccountName=${azurerm_cosmosdb_account.cosmos.name};AccountKey=${azurerm_cosmosdb_account.cosmos.primary_key};TableEndpoint=https://${azurerm_cosmosdb_account.cosmos.name}.table.cosmos.azure.com:443/;"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.appi.instrumentation_key
    linux_fx_version               = "PYTHON|3.9"

  }
  site_config {
    application_stack {
      python_version = "3.9"
    }
    cors {
      allowed_origins = [
        "*"
      ]
      support_credentials = false
    }
  }
}


resource "azurerm_resource_group_template_deployment" "slack" {
  name                = "slack"
  resource_group_name = var.rg
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/json/apicon.json")
}
resource "azurerm_resource_group_template_deployment" "logic" {
  name                = var.logic
  resource_group_name = var.rg
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/json/logic.json")
}
resource "azurerm_resource_group_template_deployment" "alert" {
  name                = var.alert
  resource_group_name = var.rg
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/json/metric-alert.json")
}


resource "azurerm_resource_group_template_deployment" "ag" {
  name                = var.ag
  resource_group_name = var.rg
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/json/action-group.json")
}

#----------------------frontend---------------------------


resource "azurerm_storage_account" "sttest" {
  name                     = var.sttest
  resource_group_name      = var.rg
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_storage_blob" "frontend" {
  for_each               = fileset("../frontend", "**/*")
  name                   = each.key
  storage_account_name   = var.sttest
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
  source                 = "../frontend/${each.key}"
  content_md5            = filemd5("../frontend/${each.key}")
}


resource "azurerm_cdn_profile" "cdnp" {
  name                = var.cdnp
  location            = var.location
  resource_group_name = var.rg
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "ep" {
  name                = var.ep
  profile_name        = var.cdnp
  location            = var.location
  resource_group_name = var.rg
  origin_host_header  = "sttestcrctopcug.z20.web.core.windows.net"

  origin {
    name      = "cloudrestopcu"
    host_name = "sttestcrctopcug.z20.web.core.windows.net"
  }

  tags = {
    environment = "crc"
  }

  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }
}

#------------------------------------------staging env------------------------------
