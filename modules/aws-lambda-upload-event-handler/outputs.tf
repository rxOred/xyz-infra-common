output "lambda_arn" {
  value = aws_lambda_function.upload_event_handler.arn
}

output "lambda_name" {
  value = aws_lambda_function.upload_event_handler.function_name
}

