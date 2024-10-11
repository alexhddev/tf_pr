resource "random_pet" "message_lambda_bucket_name" {
  prefix = "message-lambda"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.message_lambda_bucket_name.id
  force_destroy = true
}