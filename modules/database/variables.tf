variable "environment" {
  description = "Environment name (dev or prod) — used for database naming"
  type        = string
}

variable "tags" {
  description = "Common tags applied to the database"
  type        = map(string)
  default     = {}
}
variable "my_ip_address" {
  description = "Your current public IP, for direct database access during development"
  type        = string
}