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

data "aws_ami" "ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name =  "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}


resource "aws_instance" "jump_box"{
    ami = data.aws_ami.ami.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.subnet1.id
    security_groups = [aws_security_group.demo_sg.id]
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



