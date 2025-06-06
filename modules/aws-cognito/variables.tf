variable "user_pool_name" {
  type        = string
  description = "Name for the Cognito User Pool"
}

variable "identity_pool_name" {
  type        = string
  description = "Name for the Cognito Identity Pool"
}

variable "authenticated_role_name" {
  type        = string
  description = "IAM role name for authenticated users"
}

variable "upload_bucket_name" {
  type        = string
  description = "S3 bucket name for file uploads"
}
