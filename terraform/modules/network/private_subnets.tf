
resource "aws_subnet" "private_subnet" {
  count             = var.number_of_private_subnets
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]


  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "nat_ip" {
  tags = {
    Name = "petclinic-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
allocation_id = aws_eip.nat_ip.id
subnet_id     = aws_subnet.public_subnet.*.id[random_integer.random.result]

# picking random public subnet to create nat-gateway

tags = {
name = "natgateway"
}

}

resource "aws_route_table" "private-route-table" {
vpc_id = aws_vpc.main_vpc.id

tags = {
Name = "demoapp-private-rt"
}
}

resource "aws_route" "private-subnet-route" {

route_table_id         = aws_route_table.private-route-table.id
destination_cidr_block = "0.0.0.0/0"
nat_gateway_id         = aws_nat_gateway.nat_gateway.id

}

resource "aws_route_table_association" "private_subnet_association" {
count          = length(aws_subnet.public_subnet)
route_table_id = aws_route_table.private-route-table.id
subnet_id      = aws_subnet.private_subnet.*.id[count.index]
}


output "private_subnets" {
value = aws_subnet.private_subnet.*.id
}


resource "random_integer" "random" {
  max = length(aws_subnet.public_subnet)-1
min = 0
}
