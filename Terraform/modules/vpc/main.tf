# AWS VPC 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = var.vpc_name })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  depends_on = [aws_vpc.main]
  vpc_id     = aws_vpc.main.id
  tags       = merge(var.tags, { Name = "${var.vpc_name}-igw" })
}

# Public Subnets
resource "aws_subnet" "public" {
  depends_on = [aws_vpc.main]
  for_each   = var.public_subnets

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block

  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}"
      Type = "Public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  depends_on = [aws_vpc.main]
  for_each   = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}"
      Type = "Private"
    }
  )
}

# Elastic IPs para NAT Gateways
resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? { "default" = true } : {}
  domain   = "vpc"

  tags       = merge(var.tags, { Name = "${var.vpc_name}-eip" })
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  for_each      = var.enable_nat_gateway ? { "default" = true } : {}
  allocation_id = aws_eip.nat["default"].id
  # Seleciona a primeira subnet pública disponível
  subnet_id = values(aws_subnet.public)[0].id

  tags       = merge(var.tags, { Name = "${var.vpc_name}-nat" })
  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags       = merge(var.tags, { Name = "${var.vpc_name}-public-rt" })
  depends_on = [aws_internet_gateway.main]
}

# Associate public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_subnet.public]
}

# Private Route Table
resource "aws_route_table" "private" {
  # Cria uma única tabela privada se o NAT estiver ativo
  for_each = var.enable_nat_gateway ? { "main" = true } : {}
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main["default"].id
  }

  tags       = merge(var.tags, { Name = "${var.vpc_name}-private-rt" })
  depends_on = [aws_vpc.main]
}

# Associate private subnets
resource "aws_route_table_association" "private" {
  for_each  = aws_subnet.private
  subnet_id = each.value.id
  # Associa à tabela privada se ela existir, senão não faz nada (ou associa a uma padrão)
  route_table_id = length(aws_route_table.private) > 0 ? aws_route_table.private["main"].id : null
  depends_on     = [aws_subnet.private]
}