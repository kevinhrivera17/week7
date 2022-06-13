data "archive_file" "zip-email" {
  type        = "zip"
  source_file = "lamdafiles/email.py"
  output_path = "zipfiles/email.zip"
}

data "archive_file" "zip-sms" {
  type        = "zip"
  source_file = "lamdafiles/sms.py"
  output_path = "zipfiles/sms.zip"
}

data "archive_file" "zip-api-handler" {
  type        = "zip"
  source_file = "lamdafiles/api-handler.py"
  output_path = "zipfiles/api-handler.zip"
}