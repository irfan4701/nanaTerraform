resource "aws_vpc" "demo_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-VPC"
    }
}

resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
        Name = "${var.env_prefix}-IGW"
    }
}