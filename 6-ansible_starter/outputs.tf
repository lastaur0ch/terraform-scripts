output "ansible-ip" {
  value = aws_instance.ansible_server.public_ip
}

output "target-ip" {
  value = aws_instance.target_server.public_ip
}