variable "bucket_name" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}

variable "authenticated_role_name" { 
  type = string
}
