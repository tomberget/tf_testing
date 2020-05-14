terraform {
  backend "s3" {
    region         = "eu-north-1"
    bucket         = "atari-remote-state"
    key            = "terraform/terraform.tfstate"
    dynamodb_table = "atari-remote-state-lock-dev"
    encrypt        = true
  }
}