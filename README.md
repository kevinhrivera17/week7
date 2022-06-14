
# IaC | Serverless Infrastructure using TF

Challenge 6 | Week 7 | Kevin Rivera

In this Challenge, I create a fully working serverless reminder application using S3, Lambda, API Gateway, Step Functions, Simple Email Service, and Simple Notification Service.
## Features

- Using Remote State
- Using Profiles instead of Credentials


## About The Challenge
To understand what the infrastructure does is necessary to see the next workflow image![App Screenshot](https://github.com/kevinhrivera17/week7/blob/develop/images/Workflow.jpg?raw=true)

The workflow is very simple, you load the enpoint on your browser, the you should type the time you need the message takes to send the notification, than you type the message you need to be send. Then all the information is sent to an API Gateway which is linked to a main lambda in this cas api_handler, this info is sent to a state machine on Step Function, and according to the information provided on the frontend, It will take different steps, it can be a email notification, a text messahe notification or even both.

Keep in mind that emails used need to be verified manually.
## How to Run Command
To get the infrastructure on you maching you first need to dowload the source code using

```bash
git clone https://github.com/kevinhrivera17/week7.git
```
Once it is downloaded you will have to set up the credential in case you want to use them, in my case I used credentials under profile options

Once you have provided credential or you have set up your profile you will be able to run
```bash
  terraform init
```
To download all providers need, then you can run
```bash
  terraform plan
```
and finally to build the infrastructure
```bash
  terraform apply
```
When everything is done, you get on you command line the s3 endpoint.

![App Screenshot](https://github.com/kevinhrivera17/week7/blob/develop/images/EP.png?raw=true)
## Endpoint

 - [S3 Endpoint](http://challenge-bucket-2022.s3-website-us-east-1.amazonaws.com/)

## Authors

- [@kevinhrivera17](https://github.com/kevinhrivera17)

