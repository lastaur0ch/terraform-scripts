provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "remote-s3-tf-state"
}

resource "aws_s3_bucket_versioning" "s3-version" {
  bucket = aws_s3_bucket.s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terra-lock" {
  name = "terra-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}