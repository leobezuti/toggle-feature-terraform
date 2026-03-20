output "vpc_id" {
  value       = module.global_vpc.vpc_id
}

output "vpc_cidr_block" {
  value       = module.global_vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  value       = module.global_vpc.public_subnet_ids
}

output "private_subnet_ids_list" {
  value       = module.global_vpc.private_subnet_ids_list
}

output "nat_gateway_ips" {
  value = module.global_vpc.nat_gateway_ips
}

output "public_route_table_id" {
  value       = module.global_vpc.public_route_table_id
}
