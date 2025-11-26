provider "aws" {
    region = var.region
}

module "infra" {
    source = "../modules/vpc"
    env = var.env
    vpc_cidr = var.vpc_cidr
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
    region=var.region
    enable_ha= var.enable_ha
}


output "vpc_id" {
    value=module.infra.vpc_id
}

output "public_subnet_ids"{
    value=module.infra.public_subnet_ids
}

output "private_subnet_ids"{
    value=module.infra.private_subnet_ids
}