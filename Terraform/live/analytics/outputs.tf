output "table_name" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_table_name
}

output "table_arn" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_table_arn
}

output "table_id" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_table_id
}

output "stream_arn" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_stream_arn
}

output "stream_specification" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_stream_specification
}

output "global_secondary_indexes" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_global_secondary_indexes
}

output "billing_mode" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.dynamodb_billing_mode
}
