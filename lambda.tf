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

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "email_lambda" {
  filename      = "zipfiles/email.zip"
  function_name = "email"
  role          = aws_iam_role.iam_for_lambda.arn
  handler = "lambda-email.handler"
  runtime = "python3.8"
}

resource "aws_lambda_function" "sms_lambda" {
  filename      = "zipfiles/sms.zip"
  function_name = "sms"
  role          = aws_iam_role.iam_for_lambda.arn
  handler = "lambda-sms.handler"
  runtime = "python3.8"
}

resource "aws_lambda_function" "api_handler_lambda" {
  filename      = "zipfiles/api-handler.zip"
  function_name = "api-handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler = "lambda-apihandler.handler"
  runtime = "python3.8"
}