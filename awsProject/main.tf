provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "/home/irfan/.aws/credentials"
    profile = "la"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}

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

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
}

resource "aws_route_table" "rt1"{
    vpc_id = aws_vpc.demo_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }
    tags = {
        Name = "${var.env_prefix}-Route Table"
    }
}


resource "aws_route_table_association" "rt_association_1"{
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt1.id
}

resource "aws_default_route_table" "default_rt" {
    default_route_table_id = aws_vpc.demo_vpc.default_route_table_id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }
    tags = {
        Name = "${var.env_prefix}-Route Table"
    }
}

resource "aws_security_group" "demo_sg"{
    name = "Demo-SG"
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
        Name = "${var.env_prefix}-SG"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}

resource "aws_default_security_group" "demo_sg"{
#    name = "Demo-SG"
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
        Name = "${var.env_prefix}-SG"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}
