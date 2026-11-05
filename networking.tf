# Primary Subnet
resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Primary-Public-Subnet"
  }
}

# Secondary Subnet
resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Secondary-Public-Subnet"
  }
}

# Primary Internet Gateway
resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Primary-IGW"
  }
}

# Secondary Internet Gateway
resource "aws_internet_gateway" "secondary" {
  vpc_id = aws_vpc.secondary.id

  tags = {
    Name = "Secondary-IGW"
  }
}

# Primary Route Table
resource "aws_route_table" "primary" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }

  tags = {
    Name = "Primary-Route-Table"
  }
}

# Secondary Route Table
resource "aws_route_table" "secondary" {
  vpc_id = aws_vpc.secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }

  tags = {
    Name = "Secondary-Route-Table"
  }
}

# Primary Subnet Association
resource "aws_route_table_association" "primary" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.primary.id
}

# Secondary Subnet Association
resource "aws_route_table_association" "secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.secondary.id
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "primary_secondary" {
    vpc_id = aws_vpc.primary.id
    peer_vpc_id = aws_vpc.secondary.id
    auto_accept = true

    tags = {
      Name = "Primary-Secondary-Peering"
    }

}
# Route from Primary to Secondary
resource "aws_route" "primary_to_secondary" {
    route_table_id = aws_route_table.primary.id
    destination_cidr_block = aws_vpc.secondary.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.primary_secondary.id

    
}

# Route from Secondary to Primary
resource "aws_route" "secondary_to_primary" {
    route_table_id = aws_route_table.secondary.id
    destination_cidr_block = aws_vpc.primary.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.primary_secondary.id
  
}



