variable "aws_account_id" {
  type        = "string"
  description = "ID of the AWS account. Used for constructing ARNs."
}

variable "domain_name" {
  type        = "string"
  description = "DNS domain in the AWS account which you own or is linked via NS records to a DNS zone you own."
}

variable "name" {
  type        = "string"
  description = "The string that is used in the `name` filed or equivalent in most resources."
}

variable "region" {
  type        = "string"
  description = "The AWS region to use."
}

variable "tags" {
  type        = "map"
  description = "A map of tags to apply to all resources."
}
