# Public EC2
resource "aws_instance" "public_ec2" {
  ami           = "ami-0ecb62995f68bb549"  # Amazon Linux 2023 for Mumbai
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.mykey.key_name
  #key_name="demo"
  tags = {
    Name = "public-ec2"
  }
}

# Private EC2
resource "aws_instance" "private_ec2" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  # No public IP
  associate_public_ip_address = false

  key_name = aws_key_pair.mykey.key_name

  tags = {
    Name = "private-ec2"
  }
}
