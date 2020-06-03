# AWS region setting
variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

# Path to tfstate in S3 bucket
variable "s3_tfstate_key" {
  description = "Terraform state key (path)"
  default     = "terraform/terraform.tfstate"
}

## ENV variables
# adding a prefix
variable "prefix" {
  type = string
  description = "Company name or other identifier to use as a prefix"
}

# adding a environment
variable "environment" {
  type        = string
  description = "Used as postfix for naming"
}

# defining EKS cluster names
variable "cluster_name" {
  default = "atari-eks-cluster-dev"
}

# setting kubernetes version
variable "kubernetes-version" {
  default = "1.16.8"
}

# setting kubernetes version
variable "domain_name" {
  type        = string
  description = "Domain name to use for ExportDNS, nginx and ingresses"
}

variable "txt_owner_id" {
  type        = string
  description = "TxtOwnerId for ExternalDNS when using AWS Route53"
}

variable "external_dns_role_name" {
  type        = string
  description = "IAM role name to use for accessing Route53"
}