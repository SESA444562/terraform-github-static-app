output "repo_url" {
  value       = github_repository.gh_repo.html_url
  description = "The URL of the created repository."
}

output "app_url" {
  value       = "https://${var.destination_org}.github.io/${var.waypoint_application}"
  description = "The URL of the app on GitHub Pages."
}

output "app_insights_connection_string" {
  value       = azurerm_application_insights.appi.connection_string
  description = "The connection string for the created Azure Application Insights instance."
  sensitive   = true
}

output "app_insights_key" {
  value       = azurerm_application_insights.appi.instrumentation_key
  description = "The instrumentation key for the created Azure Application Insights instance."
  sensitive   = true
}
