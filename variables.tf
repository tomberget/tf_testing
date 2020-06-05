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
  type        = string
  description = "Company name or other identifier to use as a prefix"
}

# adding a environment
variable "environment" {
  type        = string
  description = "Used as postfix for naming"
}

# setting kubernetes version
variable "cluster_version" {
  type        = string
  description = "Define kubernetes version"
}

# setting domain name
variable "domain_name" {
  type        = string
  description = "Domain name to use for ExportDNS, nginx and ingresses"
}

# setting txt owner id
variable "hostedzone_id" {
  type        = string
  description = "Hosted Zone ID for ExternalDNS and Cert Manager when using AWS Route53"
}

# setting external dns role name (and lets see how long I take to remove it)
variable "external_dns_role_name" {
  default     = "ExternalDNS"
  description = "IAM role name to use for accessing Route53"
}

variable "email" {
  type        = string
  description = "Email for Lets Encrypt certificates"
}

variable "grafana_pwd" {
  type        = string
  description = "Email for Lets Encrypt certificates"
}