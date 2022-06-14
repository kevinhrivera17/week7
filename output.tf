output "invoke_url_api_reminders" {
  value = aws_api_gateway_stage.prod.invoke_url
}

output "get_endpoint_s3" {
  value = aws_s3_bucket.bucket.website_endpoint
}