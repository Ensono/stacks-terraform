#############
# Common Vars
#############
variable "tags" {
  description = "Meta data for labelling the infrastructure."
  type        = map(string)
}

############
# Dynamo DB
############
variable "enable_dynamodb" {
  default     = false
  description = "Whether to create dynamodb table."
  type        = bool
}
variable "table_name" {
  description = "The name of the table, this needs to be unique within a region."
  type        = string
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key."
  type        = string
}

variable "attribute_name" {
  description = "Name of the attribute."
  type        = string
}

variable "attribute_type" {
  description = "Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data."
}

############
# SQS & SNS
############
variable "enable_queue" {

  default     = false
  description = "Whether to create SQS queue and SNS Topic."
  type        = bool
}
variable "queue_name" {
  description = "This is the human-readable name of the queue & topic. If omitted, Terraform will assign a random name."
  type        = string
}
