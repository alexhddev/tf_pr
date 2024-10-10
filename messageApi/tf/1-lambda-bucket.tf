resource "random_pet" "name" {
  prefix = "message-lambda"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.name.id
  force_destroy = true
}