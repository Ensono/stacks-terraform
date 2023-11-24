variable "region" {
  type        = string
  description = "The name of the region to use"
}

variable "enable_registry_scanning" {
  type        = bool
  description = "Whether to enable continuous registry scanning"
}

variable "repositories" {
  type        = list(string)
  description = "A list of the repositories to create"
}

variable "max_untagged_image_count" {
  type        = number
  description = "The maximum number of untagged images to keep for each repository"

  default = 1
}

variable "max_tagged_image_count" {
  type        = number
  description = "The maximum number of tagged images to keep for each repository"
}

variable "pull_accounts" {
  type        = list(string)
  description = "List of accounts that can pull"
}

variable "pull_and_push_accounts" {
  type        = list(string)
  description = "List of accounts that can pull and push"
}

variable "repository_image_tag_mutability" {
  type        = string
  description = "Whether the repositories are MUTABLE or IMMUTABLE. Best choice is IMMUTABLE"

  default = "IMMUTABLE"

  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE"], var.repository_image_tag_mutability)
    error_message = "Can be one of 'IMMUTABLE' or 'MUTABLE'."
  }
}

## Pull Through Cache
variable "pull_through_cache_setup" {
  type = map(
    object({
      upstream_registry_url = string
      images                = list(string)
      accounts              = optional(list(string))
    })
  )
  description = "The set-up for the Pull Through Cache, an object like {ecr-public = {images = [\"foo\"] upstream_registry_url = \"public.ecr.aws\"}}"
}

variable "pull_through_cache_accounts" {
  type        = list(string)
  description = "A default list of accounts for the Pull Through Cache if not configured in the `pull_through_cache_setup`. Defaults to the calling account root"
  default     = []
}
