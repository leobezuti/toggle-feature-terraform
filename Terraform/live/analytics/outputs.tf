output "table_name" {
  value       = module.analytics_service_dynamodb.table_name
}

output "table_arn" {
  value       = module.analytics_service_dynamodb.table_arn
}

output "table_id" {
  value       = module.analytics_service_dynamodb.table_id
}

output "stream_arn" {
  value       = module.analytics_service_dynamodb.stream_arn
}

output "stream_specification" {
  value       = module.analytics_service_dynamodb.stream_specification
}

output "global_secondary_indexes" {
  value       = module.analytics_service_dynamodb.global_secondary_indexes
}

output "billing_mode" {
  value       = module.analytics_service_dynamodb.billing_mode
}
