resource "aws_ec2_transit_gateway" "tgw" {
    description="enableling conectivty between two vpc"
    amazon_side_asn = 64512
    tags ={
        Name = "${var.env}-tgw"
    }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-local-attach"{
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = var.vpc_id
    subnet_ids = var.private_subnet_ids
}
