resource "aws_api_gateway_rest_api" "api-reminders" {
  body = jsonencode({
  "openapi" : "3.0.1",
  "info" : {
    "title" : "reminders",
    "version" : "2022-06-13T19:33:31Z"
  },
  "servers" : [ {
    "url" : "https://n784vzhik6.execute-api.us-east-1.amazonaws.com/{basePath}",
    "variables" : {
      "basePath" : {
        "default" : "/prod"
      }
    }
  } ],
  "paths" : {
    "/reminders" : {
      "post" : {
        "responses" : {
          "200" : {
            "description" : "200 response",
            "content" : {
              "application/json" : {
                "schema" : {
                  "$ref" : "#/components/schemas/Empty"
                }
              }
            }
          }
        },
        "x-amazon-apigateway-integration" : {
          "httpMethod" : "POST",
          "uri" : "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:453133647817:function:api-handle/invocations",
          "responses" : {
            "default" : {
              "statusCode" : "200"
            }
          },
          "passthroughBehavior" : "when_no_match",
          "contentHandling" : "CONVERT_TO_TEXT",
          "type" : "aws"
        }
      }
    }
  },
  "components" : {
    "schemas" : {
      "Empty" : {
        "title" : "Empty Schema",
        "type" : "object"
      }
    }
  }
})

  name = "api-reminders"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "dapi-reminders" {
  rest_api_id = aws_api_gateway_rest_api.api-reminders.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api-reminders.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.dapi-reminders.id
  rest_api_id   = aws_api_gateway_rest_api.api-reminders.id
  stage_name    = "prod"
}