#########
# NAMING
##########

variable "name_company" {
  description = "ID element. Usually used to indicate specific organisation."
  type        = string
}

variable "name_project" {
  description = "ID element. Usually used to indicate specific project."
  type        = string
}


variable "name_domain" {
  description = "ID element. Usually used to indicate specific API."
  type        = string
}

variable "stage" {
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging','test', 'deploy', 'release'."
  type        = string
}

variable "attributes" {
  description = "ID element. List of attributes."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Meta data for labelling the infrastructure."
  default     = {}
}

# Each region must have corresponding a shortend name for resource naming purposes
variable "location_name_map" {
  type        = map(string)
  description = "Each region must have corresponding a shortend name for resource naming purposes."

  default = {

    us-east-1      = "use1"
    us-east-2      = "use2"
    us-west-1      = "usw1"
    us-west-2      = "usw2"
    eu-west-1      = "euw1"
    eu-west-2      = "euw2"
    eu-west-3      = "euw3"
    eu-south-1     = "eus1"
    eu-central-1   = "euc1"
    eu-north-1     = "eun1"
    ap-southeast-1 = "apse1"
    ap-northeast-1 = "apne1"
    ap-southeast-2 = "apse2"
    ap-northeast-2 = "apne2"
    sa-east-1      = "sae1"
    cn-north-1     = "cnn1"
    ap-south-1     = "aps1"
  }
}

variable "resource_group_location" {
  type        = string
  description = "AWS region-code corresponding to aws infrastrcuture deployed, example for london it should be eu-west-2."
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

######
# SQS
######
variable "enable_queue" {

  default     = false
  description = "Whether to create SQS queue."
  type        = bool
}
variable "queue_name" {
  description = "This is the human-readable name of the queue. If omitted, Terraform will assign a random name."
  type        = string
}
