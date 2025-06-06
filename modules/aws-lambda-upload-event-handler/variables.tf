variable "lambda_role_arn" {
  description = "IAM role ARN the Lambda will assume"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket triggering the Lambda"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "queue_url" {
  description = "SQS queue URL"
  type        = string
}


