provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_local" {

    ami="ami-0b6c6ebed2801a5cb"

    instance_type="t2.medium"

    tags={
        Name="Test Server via terraform"
    }
  
}