provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "state-instance" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  subnet_id = var.subnet-id
  key_name = var.key

  tags = {
    Name = "state-instance"
  }
}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "tribaxy-s3-terra"
}