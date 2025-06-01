variable "user_pool_name" {
  type = string
}

variable "app_client_name" {
  type = string
}

variable "identity_pool_name" {
  type = string
}

variable "authenticated_role_name" {
  type = string
}

variable "auto_verified_attributes" {
  type = list(string)
  default = []
}

