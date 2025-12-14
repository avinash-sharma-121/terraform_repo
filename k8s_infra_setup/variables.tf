variable "region"{
    type = string
    default = "us-east-1"
}

variable "env"{
    type = string
    default = "dev"
}

variable "vpc_cidr"{
    type = string
    default = "10.1.0.0/16"
}

variable "public_subnets"{
    type=list(string)
    default = ["10.1.1.0/24","10.1.2.0/24"]
}

variable "private_subnets"{
    type=list(string)
    default = ["10.1.3.0/24","10.1.4.0/24"]
}

variable "enable_ha" {
    type=bool
    default=true
    description = "Enable high avaiblity"
}

variable "instance_type" {
    type=string
    default="t2.medium"
}

variable "ami_id"{
    type = string
    default = "ami-0ecb62995f68bb549"
}

#Running bash script for ec2
variable "base_script"{
    type=string
    default= "k8s"
}

variable private_ec2_count {
    type = number
    default= 2
}

variable public_ec2_count {
    type = number
    default=2
}

variable root_volume_size{
    type=number
    default=40
}