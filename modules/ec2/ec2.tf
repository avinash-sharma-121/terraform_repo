# Public EC2 (Bastion Server in Public subnet)

resource "aws_instance" "public_ec2" {
  count=1
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = var.public_subnet_ids
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.mykey.key_name

  user_data = file("${path.module}/../../scripts/ansible.sh")
  
  tags = {
    Name = "${var.env}-public-ec2-${count.index+1}"
  }
}

# Private EC2 (private server)

resource "aws_instance" "private_ec2" {
  count = 4
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = var.private_subnet_ids
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  # No public IP
  associate_public_ip_address = false

  key_name = aws_key_pair.mykey.key_name

  tags = {
    Name = "${var.env}-private-ec2-${count.index+1}"
  }
}
