provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "state-instance" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  subnet_id = var.subnet-id
  key_name = var.key

  tags = {
    Name = "state-ec2"
  }
}

# resource "aws_dynamodb_table" "terra-lock" {
#   name = "terra-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }