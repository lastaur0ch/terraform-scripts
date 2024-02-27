terraform {
  backend "s3" {
    bucket = "tribaxy-s3-terra"
    key    = "tribaxy/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terra-dyntable"
  }
}