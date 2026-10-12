output "workspace_name" {
  description = "Name of the Log Analytics workspace with Sentinel."
  value       = azurerm_log_analytics_workspace.main.name
}

output "resource_group_name" {
  description = "Resource group that holds the lab."
  value       = azurerm_resource_group.main.name
}

output "analytics_rules" {
  description = "Display names of the deployed analytics rules."
  value       = [for r in azurerm_sentinel_alert_rule_scheduled.rules : r.display_name]
}
