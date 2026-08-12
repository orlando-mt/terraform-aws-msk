variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC for the cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets (2-3 AZs)"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group of the client applications"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key for encryption at rest"
  type        = string
}
