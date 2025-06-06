variable "lambda_role_arn" {
  description = "IAM role ARN the Lambda will assume"
  type        = string
}

variable "queue_arn" {
  description = "ARN of the SQS queue to trigger Lambda"
  type        = string
}

variable "from_email" {
  description = "Verified SES 'from' email address"
  type        = string
}

variable "to_email" {
  description = "Notification receiver email address"
  type        = string
}


