# ID da VPC
output "vpc_id" {
  description = "O ID da VPC"
  value       = module.global_vpc.vpc_id
}

# Bloco CIDR da VPC
output "vpc_cidr_block" {
  description = "O bloco CIDR da VPC"
  value       = module.global_vpc.vpc_cidr_block
}

# IDs das Subnets Públicas (em formato de mapa para facilitar a identificação)
output "public_subnet_ids" {
  description = "Mapa de IDs das subnets públicas"
  value       = module.global_vpc.public_subnet_ids
}

# IDs das Subnets Privadas (em formato de lista, comum para uso em Load Balancers)
output "private_subnet_ids_list" {
  description = "Lista apenas com os IDs das subnets privadas"
  value       = module.global_vpc.private_subnet_ids_list
}

# IP Elástico do NAT Gateway
output "nat_gateway_ips" {
  description = "O endereço IP público do NAT Gateway"
  # Como usamos for_each condicional, usamos o operador splat ou acesso direto à chave
  value = module.global_vpc.nat_gateway_ips
}

# IDs das Tabelas de Rotas
output "public_route_table_id" {
  description = "O ID da tabela de rotas pública"
  value       = module.global_vpc.public_route_table_id
}