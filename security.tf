# Primary Security Group
resource "aws_security_group" "primary" {
    name        = "primary-vpc-sg"
    description = "Security group for Primary EC2"
    vpc_id = aws_vpc.primary.id

    # SSH from administrator
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.admin_cidr]
    }
    # ICMP from Secondary VPC
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [aws_vpc.secondary.cidr_block]
    }
    # HTTP from internet
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "Primary-SG"
  }
}

# Secondary Security Group
resource "aws_security_group" "secondary" {
    name = "secondary-vpc-sg"
    description = "Security group for Secondary EC2"
    vpc_id = aws_vpc.secondary.id

    # SSH from administrator
    ingress {
        from_port = 22
        to_port = 22
        protocol ="tcp"
        cidr_blocks = [var.admin_cidr]
    }
    # ICMP from primary
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [aws_vpc.primary.cidr_block]
    }

    # HTTP from internet
    ingress {
        from_port = 80
        to_port = 80
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

