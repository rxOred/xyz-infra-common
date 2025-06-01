output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.identity_pool.id
}

output "authenticated_role_arn" {
  value = aws_iam_role.authenticated_role.arn
}

