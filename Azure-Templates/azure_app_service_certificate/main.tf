provider "azurerm" {
  features { }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_app_service_certificate" "example2" {
  name                = "example-cert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  pfx_blob            = filebase64("certificate.pfx")
  password            = "terraform"
}

resource "azurerm_app_service_certificate_order" "example3" {
  name                = "example-cert-order"
  resource_group_name = azurerm_resource_group.example.name
  location            = "global"
  distinguished_name  = "CN=example.com"
  product_type        = "Standard"
}

resource "azurerm_app_service_custom_hostname_binding" "example4" {
  hostname            = "www.mywebsite.com"
  app_service_name    = azurerm_app_service.example.name
  resource_group_name = azurerm_resource_group.example.name
}
