resource "aws_instance" "bastion" {
  ami                         = data.aws_ami_ids.amazon_linux.ids[0]
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

data "aws_ami_ids" "amazon_linux"{
  owners = ["137112412989"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.20201218.1-x86_64-gp2"]
  }
}

