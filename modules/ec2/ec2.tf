# Public EC2 (Bastion Server in Public subnet)

resource "aws_instance" "public_ec2" {
  count=var.public_ec2_count
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = var.public_subnet_ids
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.mykey.key_name

  user_data = file("${path.module}/../../scripts/${var.base_script}.sh")

  root_block_device {
    #device_name="root-voulme-${var.env}-public-ec2"
    volume_size=var.root_volume_size
    volume_type="gp3"
    delete_on_termination=true
  }
  
  tags = {
    Name = "${var.env}-public-ec2-${count.index+1}"
  }
}

# Private EC2 (private server)

resource "aws_instance" "private_ec2" {
  count = var.private_ec2_count
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = var.private_subnet_ids
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  # No public IP
  associate_public_ip_address = false

  key_name = aws_key_pair.mykey.key_name

  user_data = file("${path.module}/../../scripts/${var.base_script}.sh")

  root_block_device {
    #device_name="root-voulme-${var.env}-public-ec2"
    volume_size=var.root_volume_size
    volume_type="gp3"
    delete_on_termination=true
  }
  
  tags = {
    Name = "${var.env}-private-ec2-${count.index+1}"
  }
}

output "user_data_path"{
  value = "${path.module}/../../scripts/${var.base_script}.sh"
}