variable "auth" {
  type = object({
    user_pool_name     = string
    app_client_name    = string
    identity_pool_name = string
  })
  description = "Authentication-related configuration including user pool, app client, and identity pool names"
}

variable "storage" {
  type = object({
    s3 = object({
      bucket_name = string
      env         = string
    })
  })
}
