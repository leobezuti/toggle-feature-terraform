aws_region = "us-east-1"

table_name = "ToggleMasterAnalytics"

hash_key   = "event_id"

hash_key_type = "S"

billing_mode = "PAY_PER_REQUEST"

tags = {
  Environment = "prd"
  Service     = "analytics"
}