module "cognito" {
  source = "../modules/aws-cognito"

  user_pool_name          = var.auth.user_pool_name
  app_client_name         = var.auth.app_client_name
  identity_pool_name      = var.auth.identity_pool_name
  authenticated_role_name = "dev-transporter-auth-role"
}

module "upload_bucket" {
  source                  = "../modules/aws-s3"
  bucket_name             = var.storage.s3.bucket_name
  authenticated_role_name = "dev-transporter-auth-role"
  env                     = var.storage.s3.env
}
