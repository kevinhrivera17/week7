# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionSampleStepFunctionExecutionIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "policy_publish_sns" {
  name = "stepFunctionSampleSNSInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sns:Publish",
              "sns:SetSMSAttributes",
              "sns:GetSMSAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "policy_invoke_lambda" {
  name = "stepFunctionSampleLambdaFunctionInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}


// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_invoke_lambda.arn
}

/*resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {
  role       = "${aws_iam_role.iam_for_sfn.name}"
  policy_arn = "${aws_iam_policy.policy_publish_sns.arn}"
}*/

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "stf-machine"
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = jsonencode(
    {
      "Comment" : "An example of the Amazon States Language using a choice state.",
      "StartAt" : "SendReminder",
      "States" : {
        "SendReminder" : {
          "Type" : "Wait",
          "SecondsPath" : "$.waitSeconds",
          "Next" : "ChoiceState"
        },
        "ChoiceState" : {
          "Type" : "Choice",
          "Choices" : [
            {
              "Variable" : "$.preference",
              "StringEquals" : "email",
              "Next" : "EmailReminder"
            },
            {
              "Variable" : "$.preference",
              "StringEquals" : "sms",
              "Next" : "TextReminder"
            },
            {
              "Variable" : "$.preference",
              "StringEquals" : "both",
              "Next" : "BothReminders"
            }
          ],
          "Default" : "DefaultState"
        },

        "EmailReminder" : {
          "Type" : "Task",
          "Resource" : aws_lambda_function.email_lambda.arn,
          "Next" : "NextState"
        },

        "TextReminder" : {
          "Type" : "Task",
          "Resource" : aws_lambda_function.sms_lambda.arn,
          "Next" : "NextState"
        },

        "BothReminders" : {
          "Type" : "Parallel",
          "Branches" : [
            {
              "StartAt" : "EmailReminderPar",
              "States" : {
                "EmailReminderPar" : {
                  "Type" : "Task",
                  "Resource" : aws_lambda_function.email_lambda.arn,
                  "End" : true
                }
              }
            },
            {
              "StartAt" : "TextReminderPar",
              "States" : {
                "TextReminderPar" : {
                  "Type" : "Task",
                  "Resource" : aws_lambda_function.sms_lambda.arn,
                  "End" : true
                }
              }
            }
          ],
          "Next" : "NextState"
        },

        "DefaultState" : {
          "Type" : "Fail",
          "Error" : "DefaultStateError",
          "Cause" : "No Matches!"
        },

        "NextState" : {
          "Type" : "Pass",
          "End" : true
        }
      }
  })

  depends_on = [aws_lambda_function.email_lambda, aws_lambda_function.sms_lambda]

}