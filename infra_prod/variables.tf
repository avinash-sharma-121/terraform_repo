variable "region"{
    type = string
    default = "us-west-2"
}

variable "env"{
    type = string
    default = "prod"
}

variable "vpc_cidr"{
    type = string
    default = "10.2.0.0/16"
}

variable "public_subnets"{
    type=list(string)
    default = ["10.2.1.0/24","10.2.2.0/24"]
}

variable "private_subnets"{
    type=list(string)
    default = ["10.2.3.0/24","10.2.4.0/24"]
}

variable "enable_ha" {
    type=bool
    default=true
    description = "Enable high avaiblity"
}