output "irsa_role_arn" {
  description = "The ARN of IAM IRSA role created"
  value       = aws_iam_role.role.arn
}
