resource "aws_dynamodb_table" "uploads_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"  # scales automatically
  hash_key     = "upload_id"

  attribute {
    name = "upload_id"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = "dev"
  }
}

