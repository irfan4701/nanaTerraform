provider "aws"{
	region = "us-east-1"
	shared_credentials_file = "/home/irfan/.aws/credentials"
	profile = "la"		
}

variable "cidr_block" {
	type = list(object({
		cidr_block = string
		name = string
	}))	
}

variable "az" {
	type = string
}

resource "aws_vpc" "my_vpc" {
	cidr_block = var.cidr_block[0].cidr_block
	tags = {
		Name = var.cidr_block[0].name
	}
}

resource "aws_subnet" "dev-subnet" {
	vpc_id = aws_vpc.my_vpc.id
	cidr_block = var.cidr_block[1].cidr_block
	availability_zone = var.az
	tags = {
		Name = var.cidr_block[1].name
	}
}



output "vpc_id"{
	value = aws_vpc.my_vpc.id
}

output "subnet_id" {
	value = aws_subnet.dev-subnet.id
}