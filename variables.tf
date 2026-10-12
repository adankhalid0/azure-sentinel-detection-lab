variable "subscription_id" {
  description = "Azure subscription ID the lab is deployed to."
  type        = string
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "norwayeast"
}

variable "prefix" {
  description = "Short prefix used in resource names."
  type        = string
  default     = "sentlab"
}

variable "log_retention_days" {
  description = "Retention (days) for the Log Analytics workspace."
  type        = number
  default     = 30
}

variable "log_daily_quota_gb" {
  description = "Daily ingestion cap in GB. Keeps cost predictable. Use -1 for no cap."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    project = "azure-sentinel-detection-lab"
    purpose = "learning"
  }
}
