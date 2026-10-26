variable "project_id" {
  description = "The project the service account lives in and gets its roles in."
  type        = string
}

variable "account_id" {
  description = "The account ID: 6 to 30 lower-case letters, digits and hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.account_id))
    error_message = "account_id must be 6 to 30 lower-case letters, digits and hyphens."
  }
}

variable "display_name" {
  description = "The service account's display name."
  type        = string
}

variable "project_roles" {
  description = "The project roles granted to the account. Basic roles are never allowed."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for role in var.project_roles : !contains(["roles/owner", "roles/editor", "roles/viewer"], role)])
    error_message = "project_roles must not contain a basic role (owner, editor, viewer)."
  }
}
