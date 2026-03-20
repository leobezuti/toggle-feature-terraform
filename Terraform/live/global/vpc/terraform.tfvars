# Nome geral para identificar os recursos
aws_region = "us-east-1"
vpc_name   = "toggle-feature-vpc"

# Bloco principal da rede
vpc_cidr = "10.0.0.0/16"

# Configuração detalhada das subnets públicas
# Chave = Nome identificador | Valor = Objeto com CIDR e AZ
public_subnets = {
  "pub-1a" = { cidr_block = "10.0.1.0/24", az = "us-east-1a" }
  "pub-1b" = { cidr_block = "10.0.2.0/24", az = "us-east-1b" }
}

# Configuração detalhada das subnets privadas
private_subnets = {
  "pvt-1a" = { cidr_block = "10.0.3.0/24", az = "us-east-1a" }
  "pvt-1b" = { cidr_block = "10.0.4.0/24", az = "us-east-1b" }
}

# Configurações de custo e funcionalidade
enable_nat_gateway = true

# Tags globais que serão aplicadas em todos os recursos
tags = {
  Environment = "prd"
}