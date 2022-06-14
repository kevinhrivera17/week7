# !/bin/bash
set -e
apigw_url=$1
s3_bucket=$2
sed -i "s~var API_ENDPOINT = ''~var API_ENDPOINT = '$apigw_url/reminders'~g" static_website/formlogic.js
cat static_website/formlogic.js
sleep 3
aws s3 sync static_website/ s3://$s3_bucket --acl public-read --delete
sleep 3
sed -i "s~var API_ENDPOINT = '$apigw_url/reminders'~var API_ENDPOINT = ''~g" static_website/formlogic.js