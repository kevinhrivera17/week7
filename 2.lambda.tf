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

  assume_role_policy = jsonencode({
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
})
}

resource "aws_iam_policy" "policy" {
  name        = "lambda-policy"
  path        = "/"
  description = "My Lambda!"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "ses:*",
          "states:*",
          "sns:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}


resource "aws_lambda_function" "email_lambda" {
  filename      = "zipfiles/email.zip"
  function_name = "email"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "email.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "sms_lambda" {
  filename      = "zipfiles/sms.zip"
  function_name = "sms"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "sms.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "api_handler_lambda" {
  filename      = "zipfiles/api-handler.zip"
  function_name = "api-handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "api-handler.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      STF_ARN = aws_sfn_state_machine.sfn_state_machine.arn
    }
  }

  depends_on = [aws_sfn_state_machine.sfn_state_machine]
}

resource "aws_iam_policy_attachment" "lambda-attachment" {
  name       = "lambda-attachment"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.policy.arn
}