variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be 'dev' or 'prod'."
  }
}

variable "environment_variables" {
  description = "Map of environment variables to set for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "organization" {
  description = "GitHub organization name, used in resource tags and repository URL"
  type        = string
  default     = "SthoreH"
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
  # TODO: trocar pelo nome real do repositório (usado na tag Repository de todos os recursos)
  default = "tpl-app-aws-lbd-python"
}

