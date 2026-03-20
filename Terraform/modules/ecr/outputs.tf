output "repository_urls" {
  description = "ECR repository URLs"
  value       = { for repo in aws_ecr_repository.repo : repo.name => repo.repository_url }
}