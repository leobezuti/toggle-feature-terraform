# ID da VPC
output "vpc_id" {
  description = "O ID da VPC"
  value       = aws_vpc.main.id
}

# Bloco CIDR da VPC
output "vpc_cidr_block" {
  description = "O bloco CIDR da VPC"
  value       = aws_vpc.main.cidr_block
}

# IDs das Subnets Públicas (em formato de mapa para facilitar a identificação)
output "public_subnet_ids" {
  description = "Mapa de IDs das subnets públicas"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

# IDs das Subnets Privadas (em formato de lista, comum para uso em Load Balancers)
output "private_subnet_ids_list" {
  description = "Lista apenas com os IDs das subnets privadas"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

# IP Elástico do NAT Gateway
output "nat_gateway_ips" {
  description = "O endereço IP público do NAT Gateway"
  # Como usamos for_each condicional, usamos o operador splat ou acesso direto à chave
  value = var.enable_nat_gateway ? aws_eip.nat["default"].public_ip : null
}

# IDs das Tabelas de Rotas
output "public_route_table_id" {
  description = "O ID da tabela de rotas pública"
  value       = aws_route_table.public.id
}