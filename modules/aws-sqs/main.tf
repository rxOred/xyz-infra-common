resource "aws_sqs_queue" "this" {
  name = var.queue_name

  # Optional: Enable long polling (better for Lambda triggers)
  receive_wait_time_seconds = 10

  # Optional: Set retention period (default is 4 days)
  message_retention_seconds = 345600  # 4 days

  tags = {
    Name        = var.queue_name
    Environment = "dev"
  }
}

