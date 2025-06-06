variable "ses_from_email" {
  description = "The verified email address used as the sender for SES notifications"
  type        = string
}

variable "ses_to_email" {
  description = "The recipient email address to receive upload notifications"
  type        = string
}

