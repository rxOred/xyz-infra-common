variable "upload_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "uploads_table_arn" {
  description = "DynamoDB table ARN"
  type        = string
}

variable "queue_arn" {
  description = "SQS queue ARN"
  type        = string
}

