provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "prov-key-tf" {
  key_name = "prov-key-tf"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "prov-vpc" {
  cidr_block = var.vpc-cidr
}

resource "aws_internet_gateway" "prov-igw" {
  vpc_id = aws_vpc.prov-vpc.id
}

resource "aws_subnet" "prov-subnet" {
  vpc_id = aws_vpc.prov-vpc.id
  cidr_block = var.subnet-cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "prov-RT" {
  vpc_id = aws_vpc.prov-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prov-igw.id
  }
}

resource "aws_route_table_association" "prov-rta" {
  subnet_id = aws_subnet.prov-subnet.id
  route_table_id = aws_route_table.prov-RT.id
}

resource "aws_security_group" "prov-web-sg" {
  name = "web"
  vpc_id = aws_vpc.prov-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "prov-web-sg"
  }
}

resource "aws_instance" "prov-server" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name = aws_key_pair.prov-key-tf.key_name
  vpc_security_group_ids = [ aws_security_group.prov-web-sg.id ]
  subnet_id = aws_subnet.prov-subnet.id

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [ 
        "echo 'Hello from the remote instance'",
        "sudo apt update -y",
        "sudo apt-get install -y python3-pip",
        "cd /home/ubuntu",
        "sudo pip3 install flask",
        # "sudo python3 app.py"
     ]
  }

  tags = {
    Name = "Provision Server"
  }
}

output "instance-ip" {
  value = aws_instance.prov-server.public_ip
}