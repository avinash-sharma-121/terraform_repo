
resource "aws_vpc" "main_vpc"{
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    //enable_dns_hostnames = ture

    tags ={
        Name = "${var.env}-vpc"
    }
}

resource "aws_subnet" "public_subnet"{
    count = length(var.public_subnets)
    vpc_id=aws_vpc.main_vpc.id
    cidr_block = var.public_subnets[count.index]

    tags = {
        Name = "${var.env}-public-${count.index + 1}"
    }
}

resource "aws_subnet" "private_subnet"{
    count = length(var.private_subnets)
    vpc_id= aws_vpc.main_vpc.id
    cidr_block = var.private_subnets[count.index]

    tags ={
        Name = "${var.env}-private-${count.index +1}"
    }
}

resource "aws_internet_gateway" "igw"{
    vpc_id=aws_vpc.main_vpc.id

    tags = {
        Name = "${var.env}-igw"
    }
}

resource "aws_eip" "net_eip"{
    count = var.enable_ha ? 2 : 1
    domain = "vpc"

    tags = {
        Name = "${var.env}-eip-${count.index+1}",
        Created_by = "Avinash"
    }
}

resource "aws_nat_gateway" "ngw" {
    count = var.enable_ha ? 2 : 1
    allocation_id = aws_eip.net_eip[count.index].id
    subnet_id = "${aws_subnet.public_subnet[count.index].id}"

    tags = {
        Name = "${var.env}-nat-gw-${count.index+1}"
    }
    
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt"{
    count = var.enable_ha ? length(var.public_subnets) : 1
    vpc_id = aws_vpc.main_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.env}-public-rt-${count.index+1}"
    }
}

resource "aws_route_table" "private_rt"{
    count = var.enable_ha ? length(var.private_subnets) :1
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw[count.index].id
    }

    tags = {
        Name = "${var.env}-private-rt-${count.index+1}"
    }
   
}

#subnet association with route Table

resource "aws_route_table_association" "rt_assocaition_pub"{
    count = var.enable_ha ? length(var.public_subnets) : 1
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_route_table_association" "rt_associateion_pri"{
    count = var.enable_ha ? length(var.private_subnets) : 1
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt[count.index].id
}

