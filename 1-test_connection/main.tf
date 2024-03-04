provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_connection" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = var.subnet-id
  key_name = var.key
  tags = {
    Name = "test_instance"
  }
}

output "public-ip" {
  value = aws_instance.test_connection.public_ip
}