# --- Cognito User Pool ---
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  username_attributes = ["email"]

  auto_verified_attributes = ["email"]
}

# --- User Pool Client ---
resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.user_pool_name}-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  generate_secret = false
}

# --- Cognito Identity Pool ---
resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id = aws_cognito_user_pool_client.client.id
    provider_name = aws_cognito_user_pool.user_pool.endpoint
  }
}

# --- IAM Role for Authenticated Users ---
resource "aws_iam_role" "authenticated_role" {
  name = var.authenticated_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "cognito-identity.amazonaws.com"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.identity_pool.id
        },
        "ForAnyValue:StringLike" = {
          "cognito-identity.amazonaws.com:amr" = "authenticated"
        }
      }
    }]
  })
}

# --- IAM Policy: S3 Upload Access to User-Specific Folder ---
resource "aws_iam_role_policy" "authenticated_policy" {
  name = "TransporterS3Access"
  role = aws_iam_role.authenticated_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${var.upload_bucket_name}/uploads/$${cognito-identity.amazonaws.com:sub}/*"
      }
    ]
  })
}

# --- Attach Role to Identity Pool ---
resource "aws_cognito_identity_pool_roles_attachment" "default" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id

  roles = {
    authenticated = aws_iam_role.authenticated_role.arn
  }
}

