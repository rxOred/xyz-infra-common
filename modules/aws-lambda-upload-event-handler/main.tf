resource "aws_lambda_function" "upload_event_handler" {
  function_name    = "UploadEventHandlerLambda"
  filename         = "${path.module}/upload_event_handler.zip"
  source_code_hash = filebase64sha256("${path.module}/upload_event_handler.zip")
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = var.lambda_role_arn

  environment {
    variables = {
      QUEUE_URL  = var.queue_url
      TABLE_NAME = var.table_name
    }
  }

  tags = {
    Environment = "dev"
    Function    = "upload_event_handler"
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_event_handler.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.upload_event_handler.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

