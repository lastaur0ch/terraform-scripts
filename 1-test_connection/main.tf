provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_connection" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = "subnet"
  key_name = "key"
  tags = {
    Name = "test_instance"
  }
}