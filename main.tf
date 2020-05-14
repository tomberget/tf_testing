# create an assumed role
resource "aws_iam_role" "assumed_role" {
  name = "assumed_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::remote-state"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::${var.s3_tfstate_key}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:dynamodb-terraform-state-lock/${var.prefix}-remote-state-lock-${var.environment}"
    }
  ]
}
POLICY
}

# create a bucket for remote state file
resource "aws_s3_bucket" "bucket" {
  bucket = "remote-state"
  acl    = "private"

  tags = {
    Name        = "remote-state"
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