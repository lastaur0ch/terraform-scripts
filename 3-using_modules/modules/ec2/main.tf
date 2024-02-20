resource "aws_instance" "module-server" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  subnet_id = var.subnet_id_value

  tags = {
    Name = "module-server"
  }
}