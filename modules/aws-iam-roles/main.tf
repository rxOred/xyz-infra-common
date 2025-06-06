resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-permissions"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = "arn:aws:s3:::${var.upload_bucket_name}/*"
      },
      {
        Effect = "Allow",
        Action = ["dynamodb:PutItem", "dynamodb:UpdateItem"],
        Resource = var.uploads_table_arn
      },
      {
        Effect = "Allow",
        Action = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
        Resource = var.queue_arn
      },
      {
        Effect = "Allow",
        Action = ["ses:SendEmail", "ses:SendRawEmail"],
        Resource = "*"
      }
    ]
  })
}

