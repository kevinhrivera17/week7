resource "aws_s3_bucket" "bucket" {
  bucket        = "challenge-bucket-2022"
  acl           = "public-read"
  force_destroy = true

  provisioner "local-exec" {
    #command = "sed -i 's/var API_ENDPOINT = ''/var API_ENDPOINT = '${aws_api_gateway_stage.prod.invoke_url}'/g' formlogic.js  && aws s3 sync static_website/ s3://${aws_s3_bucket.bucket.bucket} --acl public-read --delete"
    command = "bash updatejs.sh ${aws_api_gateway_stage.prod.invoke_url} ${aws_s3_bucket.bucket.bucket}"
  }

  website {
    index_document = "index.html"
  }

}