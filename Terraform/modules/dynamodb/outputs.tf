# Nome da tabela
output "table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.this.name
}

# ARN da tabela
output "table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = aws_dynamodb_table.this.arn
}

# ID da tabela
output "table_id" {
  description = "ID da tabela DynamoDB"
  value       = aws_dynamodb_table.this.id
}

# Stream ARN (se habilitado)
output "stream_arn" {
  description = "ARN do stream da tabela"
  value       = try(aws_dynamodb_table.this.stream_arn, null)
}

# Stream specification
output "stream_specification" {
  description = "Especificação do stream"
  value = {
    stream_enabled   = aws_dynamodb_table.this.stream_enabled
    stream_view_type = try(aws_dynamodb_table.this.stream_view_type, null)
  }
}

# Índices secundários globais
output "global_secondary_indexes" {
  description = "Lista de índices secundários globais"
  value = [
    for gsi in aws_dynamodb_table.this.global_secondary_index : {
      name = gsi.name
      arn  = gsi.arn
    }
  ]
}

# Modo de cobrança
output "billing_mode" {
  description = "Modo de cobrança da tabela"
  value       = aws_dynamodb_table.this.billing_mode
}
