variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}
