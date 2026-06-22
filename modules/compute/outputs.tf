output "backend_url" {
  description = "Default hostname of the backend App Service"
  value       = azurerm_linux_web_app.backend.default_hostname
}

output "frontend_url" {
  description = "Default hostname of the frontend App Service"
  value       = azurerm_linux_web_app.frontend.default_hostname
}

output "backend_identity_principal_id" {
  description = "Principal ID of the backend App Service's Managed Identity"
  value       = azurerm_linux_web_app.backend.identity[0].principal_id
}

output "frontend_identity_principal_id" {
  description = "Principal ID of the frontend App Service's Managed Identity"
  value       = azurerm_linux_web_app.frontend.identity[0].principal_id
}

output "service_plan_id" {
  description = "ID of the shared App Service Plan"
  value       = azurerm_service_plan.main.id
}