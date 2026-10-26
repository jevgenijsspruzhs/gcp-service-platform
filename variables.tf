variable "project_id" {
  description = "The Google Cloud project the platform runs in."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "The region of the bucket, the image repository and the service."
  type        = string
  default     = "europe-west6"
}

variable "environment" {
  description = "The environment: dev, staging or prod."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "service_name" {
  description = "The service's name; it prefixes every resource's name."
  type        = string
  default     = "inventory-api"
}

variable "image_tag" {
  description = "The tag of the container image to run, from the platform's image repository."
  type        = string
  default     = "latest"
}

variable "min_instances" {
  description = "The minimum number of Cloud Run instances kept warm."
  type        = number
  default     = 0
}
