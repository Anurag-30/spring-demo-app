data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "demoapp-IGW"
  }
}


resource "aws_subnet" "public_subnet" {
  count             = var.number_of_public_subnets
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + var.number_of_private_subnets)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }

  depends_on = [aws_subnet.private_subnet]

}

# Route Tables and Association

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "demoapp-public-rt"
  }
}

resource "aws_route" "public-subnet-route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_igw.id
  depends_on             = [aws_route_table.public_route_table, aws_internet_gateway.aws_igw]
}

resource "aws_route_table_association" "public-subnet-association" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]

}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}