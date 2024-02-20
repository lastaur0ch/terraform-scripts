output "public-ip" {
  value = aws_instance.module-server.public_ip
}