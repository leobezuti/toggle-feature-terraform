output "db_instance_endpoint" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.rds_flag_endpoint
}

output "db_instance_address" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.rds_flag_address
}

output "db_instance_port" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.rds_flag_port
}

output "db_name" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.rds_flag_name
}

output "db_username" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.rds_flag_username
}
