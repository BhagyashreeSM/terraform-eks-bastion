output "aws_bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "aws_bastion_public_ip" {
  value = aws_eip.bastion.public_ip
}
