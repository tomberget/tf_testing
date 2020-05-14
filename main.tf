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