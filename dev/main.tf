terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket = "xyz-logistics-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- S3 Bucket ---
module "s3" {
  source      = "../modules/aws-s3"
  bucket_name = "xyz-logistics-uploads-bucket-dev"
}

# --- DynamoDB ---
module "dynamodb" {
  source     = "../modules/aws-dynamodb"
  table_name = "uploads_table"
}

# --- SQS Queue ---
module "sqs" {
  source     = "../modules/aws-sqs"
  queue_name = "xyz-upload-events-queue-dev"
}

# --- IAM Roles for Lambdas ---
module "iam" {
  source             = "../modules/aws-iam-roles"
  upload_bucket_name = module.s3.bucket_name
  uploads_table_arn  = module.dynamodb.table_arn
  queue_arn          = module.sqs.queue_arn
  depends_on         = [module.s3, module.sqs, module.dynamodb]
}

# --- Cognito Auth Setup ---
module "cognito" {
  source                  = "../modules/aws-cognito"
  user_pool_name          = "xyz-logistics-user-pool-dev"
  identity_pool_name      = "xyz-logistics-identity-pool-dev"
  authenticated_role_name = "dev-transporter-auth-role"
  upload_bucket_name      = module.s3.bucket_name
}

# --- UploadEventHandler Lambda ---
module "upload_event_lambda" {
  source          = "../modules/aws-lambda-upload-event-handler"
  bucket_name     = module.s3.bucket_name
  table_name      = module.dynamodb.table_name
  queue_url       = module.sqs.queue_url
  lambda_role_arn = module.iam.lambda_exec_role_arn
  depends_on      = [module.iam]
}

# --- UploadNotification Lambda ---
module "upload_notify_lambda" {
  source          = "../modules/aws-lambda-upload-notification"
  lambda_role_arn = module.iam.lambda_exec_role_arn
  queue_arn       = module.sqs.queue_arn
  from_email      = var.ses_from_email
  to_email        = var.ses_to_email
  depends_on      = [module.iam]
}

