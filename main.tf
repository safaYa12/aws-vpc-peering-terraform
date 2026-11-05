resource "aws_vpc" "primary" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Primary-VPC"
    Environment = "Development"
  }
}

resource "aws_vpc" "secondary" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Secondary-VPC"
    Environment = "Development"
  }
}
