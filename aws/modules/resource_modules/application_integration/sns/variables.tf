variable "create" {
  description = "Whether to create SNS queue"
  type        = bool
  default     = true
}

variable "name" {
  description = "This is the human-readable name of the queue. If omitted, Terraform will assign a random name."
  type        = string
  default     = null
}

variable "create_sqs_subscription" {
  description = "Whether to create SNS subcription to the supplied SQS queue"
  type        = bool
  default     = true
}

variable "subscription_sqs_queue_arn" {
  description = "The SQS Queue ARN to subscribe this SNS topic to."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
