# AWS region setting
variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "s3_tfstate_key" {
  description = "Terraform state key (path)"
  default     = "terraform/terraform.tfstate"
}

variable "prefix" {
  default = "atari"
}

variable "environment" {
  default = "dev"
}