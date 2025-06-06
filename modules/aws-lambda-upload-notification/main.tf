resource "aws_lambda_function" "upload_notification" {
  function_name    = "UploadNotificationLambda"
  filename         = "${path.module}/upload_notification.zip"
  source_code_hash = filebase64sha256("${path.module}/upload_notification.zip")
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = var.lambda_role_arn

  environment {
    variables = {
      FROM_EMAIL = var.from_email
      TO_EMAIL   = var.to_email
    }
  }

  tags = {
    Environment = "dev"
    Function    = "upload_notification"
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.upload_notification.arn
  batch_size       = 5
  enabled          = true
}

