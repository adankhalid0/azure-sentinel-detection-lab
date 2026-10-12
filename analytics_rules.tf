# Scheduled analytics rules. The KQL lives in queries/ so it can be read and tested on its own.

locals {
  rules = {
    role_assignment = {
      display_name = "Role assignment created or changed"
      description  = "Someone was given (or changed) a role in Azure. New roles are a common step when an attacker tries to gain more access."
      severity     = "Medium"
      tactics      = ["PrivilegeEscalation"]
      query_file   = "role-assignment.kql"
    }
    resource_group_deleted = {
      display_name = "Resource group deleted"
      description  = "A whole resource group was deleted. This removes everything inside it and can be used to cause damage or hide traces."
      severity     = "High"
      tactics      = ["Impact"]
      query_file   = "resource-group-deleted.kql"
    }
    policy_changed = {
      display_name = "Azure Policy assignment changed or removed"
      description  = "A policy assignment was created, changed or deleted. Removing policy is one way to switch off a guardrail."
      severity     = "Medium"
      tactics      = ["DefenseEvasion"]
      query_file   = "policy-changed.kql"
    }
    failed_operations_burst = {
      display_name = "Burst of failed operations from one caller"
      description  = "One account tried many operations that failed in a short time. This can mean a person or script is probing what it is allowed to do."
      severity     = "Low"
      tactics      = ["Discovery"]
      query_file   = "failed-operations-burst.kql"
    }
  }
}

resource "azurerm_sentinel_alert_rule_scheduled" "rules" {
  for_each = local.rules

  name                       = "${var.prefix}-${replace(each.key, "_", "-")}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  display_name               = each.value.display_name
  description                = each.value.description
  severity                   = each.value.severity
  tactics                    = each.value.tactics
  enabled                    = true

  query             = file("${path.module}/queries/${each.value.query_file}")
  query_frequency   = "PT5M"
  query_period      = "PT10M"
  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  incident {
    create_incident_enabled = true

    grouping {
      enabled = false
    }
  }

  depends_on = [azurerm_sentinel_log_analytics_workspace_onboarding.main]
}
