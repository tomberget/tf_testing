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
  default = "atari"
}

# adding a environment
variable "environment" {
  default = "dev"
}

# defining EKS cluster names
variable "cluster-name" {
  default = "atari-eks-cluster-dev"
}

# setting kubernetes version
variable "kubernetes-version" {
  default = "1.16.8"
}