output "lambda_name" {
  value = aws_lambda_function.upload_notification.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.upload_notification.arn
}

