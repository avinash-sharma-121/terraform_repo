provider "aws"{
    region = var.region
}

module "vpc" {
    source = "../modules/vpc"
    env = var.env
    vpc_cidr = var.vpc_cidr
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
    region=var.region
}

/*
output "vpc_cidr" {
    value=module.vpc.vpc_main.id
}
*/
