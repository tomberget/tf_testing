# tf_testing

Trying out Terraform on AWS

Omitted from this Terraform script is how to make the S3 bucket for state, and the DynamoDB state lock. These items are necessary in order to make the backend work as it is supposed to, as well as not destroying them in case that you want to build and tear down the EKS cluster immediately.

The S3 bucket and dynamodb, necessary for the backend.tf, can be created by running terraform using the following script:

```terraform
#Define terraform version to use
terraform {
  required_version = ">= 0.12.25"
}

#Create the provider, remember to change region - if necessary
provider "aws" {
  region  = "eu-north-1"
  version = ">= 2.38.0"
}

# AWS region setting
variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

## ENV variables
# adding a prefix
variable "prefix" {
  default = "<your-prefix-here>"
}

# adding a environment
variable "environment" {
  default = "<your_environment_here>"
}

# create a bucket for remote state file
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.prefix}-remote-state"
  acl    = "private"

  tags = {
    Name        = "${var.prefix}-remote-state"
    Environment = var.environment
  }

  versioning {
    enabled = true
  }
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "${var.prefix}-remote-state-lock-${var.environment}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.prefix}-remote-state-lock-${var.environment}"
    Environment = var.environment
  }

  depends_on = [aws_s3_bucket.bucket]
}

```

Note that the "prefix" and "environment" variables must be the same as what you assign this terraform, in order for the correct S3 bucket and DynamoDB to be picked up by the backend.

## Connecting to the EKS cluster after creation

Much like the Jackson 5, it's as easy as ABC.. Look no further than this article from Amazon:
[EKS cluster connection](https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/)
