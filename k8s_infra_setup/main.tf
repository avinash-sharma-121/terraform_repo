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

output "available_zone" {
    value=module.infra.av_zones.names
}

output "user_data_path"{
    value=module.ec2.user_data_path
}

/*
module "tgw" {
    source = "../modules/transite-gatway"
    env = var.env
    region=var.region
    vpc_id=module.infra.vpc_id
    private_subnet_ids=module.infra.private_subnet_ids
}
*/

# Creating ec2

module "ec2" {
    source = "../modules/ec2"
    vpc_id=module.infra.vpc_id
    env=var.env
    public_subnet_ids="${module.infra.public_subnet_ids[0]}"
    private_subnet_ids="${module.infra.private_subnet_ids[0]}"
    region=var.region
    instance_type=var.instance_type
    ami_id=var.ami_id
    base_script=var.base_script
    private_ec2_count=var.private_ec2_count
    public_ec2_count=var.public_ec2_count
    root_volume_size=var.root_volume_size
}
