terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate random string for unique names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-${random_string.suffix.result}"
  location = var.location
  
  tags = {
    Environment = "Production"
    Project     = "NginxWebApp"
    ManagedBy   = "Terraform"
  }
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "nginxappacr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
  
  tags = {
    Environment = "Production"
    Project     = "NginxWebApp"
  }
}

# Container Instance
resource "azurerm_container_group" "webapp" {
  name                = "${var.container_name}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.dns_name_label}-${random_string.suffix.result}"
  os_type             = "Linux"
  restart_policy      = "Always"

  container {
    name   = "nginx-webapp"
    image  = "${azurerm_container_registry.acr.login_server}/nginx-webapp:latest"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "NGINX_HOST" = "localhost"
      "NGINX_PORT" = "80"
    }

    # Volume mount for logs (optional)
    volume {
      name       = "nginx-logs"
      mount_path = "/var/log/nginx"
      read_only  = false
      empty_dir  = true
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  tags = {
    Environment = "Production"
    Project     = "NginxWebApp"
    ManagedBy   = "Terraform"
  }

  depends_on = [azurerm_container_registry.acr]
}

# Log Analytics Workspace (optional)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "logs-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}