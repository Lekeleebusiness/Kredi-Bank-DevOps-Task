#vpc created to launch our resources
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "Kredi-prod-vpc"
  }
}

#data sources used to automatically get the availability zones in us-east-1 instead of declaring it manually. 
data "aws_availability_zones" "us_east_1" {
  state = "available"
}

#internet gateway is used to allow the vpc have access to the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Kredi-prod-internet-igw"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_1_cidr_block
  availability_zone = data.aws_availability_zones.us_east_1.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "kredi-prod-public-subnet-1"
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/kredi-cluster" = "shared"
  
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_2_cidr_block
  availability_zone = data.aws_availability_zones.us_east_1.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "kredi-prod-public-subnet-2"
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/kredi-cluster" = "shared"
  
  }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_1_cidr_block
  availability_zone = data.aws_availability_zones.us_east_1.names[0]
  map_public_ip_on_launch = false
  

  tags = {
    Name = "kredi-prod-private-subnet-1"
    "kubernetes.io/role/internal-elb"          = "1"
    "kubernetes.io/cluster/kredi-cluster" = "shared"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_2_cidr_block
  availability_zone = data.aws_availability_zones.us_east_1.names[1]
  map_public_ip_on_launch = false
  

  tags = {
    Name = "kredi-prod-private-subnet-2"
    "kubernetes.io/role/internal-elb"          = "1"
    "kubernetes.io/cluster/kredi-cluster" = "shared"
  }
} 

resource "aws_subnet" "database_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.database_cidr_block_1
  availability_zone = data.aws_availability_zones.us_east_1.names[0]
  

  tags = {
    Name = "kredi-prod-database-subnet-1"
  }
}

resource "aws_subnet" "database_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.database_cidr_block_2
  availability_zone = data.aws_availability_zones.us_east_1.names[1]
  

  tags = {
    Name = "kredi-prod-database-subnet-2"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "kredi-prod-public-route-table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_route.id
}


resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "kredi-prod-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_1.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "kredi-prod-nat-gateway"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "kredi-prod-private-route-table"
  }
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "database_1" {
  subnet_id      = aws_subnet.database_1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "database_2" {
  subnet_id      = aws_subnet.database_2.id
  route_table_id = aws_route_table.private_route.id
}






