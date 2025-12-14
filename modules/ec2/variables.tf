variable "region"{
    type = string
}

variable "vpc_id" {
    description = "The ID of the VPC where the instances will be deployed"
    type        = string
}

variable "public_subnet_ids"{
    #type = list(string)
    type = string
    description = "List of public subnet IDs"
}

variable "private_subnet_ids"{
    #type = list(string)
    type = string
    description = "List of private subnet IDs"
}

variable "instance_type" {
    type = string
}

variable "ami_id" {
    type = string
}

variable "env"{
    type = string
}

#Running bash script for ec2
variable "base_script"{
    type=string
    #default= "basic"
}

variable private_ec2_count {
    type=number
}

variable public_ec2_count {
    type=number
}

variable root_volume_size{
    type=number
}