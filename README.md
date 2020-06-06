# Credit

Much inspiration and code has been shifted and lifted from @Starefossen: <https://github.com/evry-ace/kubernetes-on-air>

## Creating a basic spot instance EKS cluster using terraform

This repository provides the basic necessities for an EKS cluster. This includes:

- Basic VPCs with subnets forced to a and b Availability Zones
- An EKS cluster
  - Using t3.small spot instances
- A NGINX ingress controller
- EXTERNAL DNS to maintain your Route53 hosted zone
  - The policy and role necessary for EXTERNAL DNS to make changes to Route53
- CERT MANAGER to provide Lets Encrypt certificates for your A records
  - The policy and role necessary for CERT MANAGER to request certificates, and a cluster issuer to issue certificates
- PROMETHEUS OPERATOR to provide insights, alerts and GRAFANA dashboards
- A basic dashboard in GRAFANA: <https://grafana.com/grafana/dashboards/7249>
  - I've made some changes to the dashboard in order to make it work according to the Terraform script, and EKS
- Some default dashboards in GRAFANA

Sadly, I have not been able to expose the NGINX ingress controller metrics to PROMETHEUS. Hopefully, I will find out why it does not work, and subsequently force it to work :)

## Before you begin

Omitted from this Terraform script is how to make the S3 bucket for state, and the DynamoDB state lock. These items are necessary in order to make the backend work as it is supposed to, as well as not destroying them in case that you want to build and tear down the EKS cluster immediately.

The S3 bucket and dynamodb, necessary for the backend.tf, can be created by running terraform using the following script:

```terraform
#Define terraform version to use
terraform {
  required_version = ">= 0.12.25"
}

#Create the provider, remember to change region - if necessary
provider "aws" {
  region  = var.aws_region
  version = ">= 2.38.0"
}

# AWS region setting
variable "aws_region" {
  description = "AWS region"
  default     = "<your-region-here>"
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

Note that the "prefix" and "environment" variables must be the same as what you assign this Terraform, in order for the correct S3 bucket and DynamoDB to be picked up by the backend.

## What you need in addition, and why

The following variables must be filled in, else this script simply will not work (withou tweaking).

```terraform
environment     = "your environment (dev, test, staging, prod)"
domain_name     = "a domain name you own, like example.com"
prefix          = "a prefix, like your company name"
cluster_version = "the Kubernetes version to use for EKS, currently 1.16 is the highest"
hostedzone_id   = "the Hosted Zone ID of the domain you own, hosted by Amazon using Route53"
email           = "the email address you want to receive notifications regarding lets encrypt certificates"
grafana_pwd     = "a new grafana admin password (currently does not work.. always reverts to default password of the operator)"
```

All of these variables are used while creating the resources this Terraform script contains. These can be added by copying/pasting them into a terraform.tfvars file; placed in the root folder. If not, they must be added as variables according to how Terraform can interpret them. See <https://www.terraform.io/docs/configuration/variables.html> for more information.

### Example

```bash
export TF_VAR_environment = "staging"
```

Exporting the above variable would set the environment variable to staging, without the need of a terraform.tfvars file to do so.

## Connecting to the EKS cluster after creation

Much like the Jackson 5, it's as easy as ABC.. Look no further than this article from Amazon:
[EKS cluster connection](https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/)
