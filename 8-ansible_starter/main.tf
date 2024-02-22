provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "ansible_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "ansible_server" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = "subnet"
  key_name = var.key-name
  
  user_data = <<-EOF
  #!/bin/bash -ex

  sudo apt update
  sudo apt install software-properties-common -y
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible -y

  EOF

  tags = {
    Name = "ansible_server"
  }
}

resource "aws_instance" "target_server" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = "subnet-0e11d1bc0fa347587"
  key_name = "terra-key"
  tags = {
    Name = "target_server"
  }
}