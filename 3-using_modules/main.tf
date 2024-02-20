provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"
  ami_value = "ami-0c7217cdde317cfec"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet"
}