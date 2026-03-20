output "queue_url" {
  description = "URL da fila SQS"
  value       = aws_sqs_queue.example_queue.id  
}

output "queue_arn" {
    description = "ARN da fila SQS"
    value       = aws_sqs_queue.example_queue.arn  
}

output "queue_id" {
    description = "ID da fila SQS"
    value       = aws_sqs_queue.example_queue.id  
}