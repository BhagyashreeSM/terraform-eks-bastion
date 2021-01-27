resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  key_name                    = var.ssh_key_pair_name

  vpc_security_group_ids = var.security_group_ids

  tags = merge(var.tags, map(
    "Name", "${var.platform_name}-bastion",
    "kubernetes.io/cluster/${var.platform_name}", var.platform_name
    )
  )
}

resource "aws_eip" "bastion" {
  tags = merge(var.tags, map(
    "Name", "${var.platform_name}-bastion",
    "kubernetes.io/cluster/${var.platform_name}", var.platform_name
  ))
}

resource "aws_eip_association" "eip_bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

