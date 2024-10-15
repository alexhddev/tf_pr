resource "aws_iam_role" "messages_lambda_iam_role" {
  name = "s3-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "messages_lambda_policy_attachment" {
  role       = aws_iam_role.messages_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "messages_lambda_policy" {
  name        = "TestS3BucketAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.messages_bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.messages_bucket.id}"
          ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "messages_lambda_role_policy_attachment" {
  role       = aws_iam_role.messages_lambda_iam_role.name
  policy_arn = aws_iam_policy.messages_lambda_policy.arn
}

resource "null_resource" "pip_install" {
  triggers = {
    shell_hash = "${sha256(file("${path.module}/../py/services/requirements.txt"))}"
  }

  provisioner "local-exec" {
    command = <<EOT
    cd ../py/services
    python -m pip install -r requirements.txt -t ${path.module}/layer/python
    EOT
  }
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/layer"
  output_path = "${path.module}/layer.zip"
  depends_on  = [null_resource.pip_install]
}

data "archive_file" "messages_lambda_archive" {
  type = "zip"

  source_dir  = "../${path.module}/py/services"
  output_path = "../${path.module}/tf/.terraform/messages.zip"
}


resource "aws_lambda_layer_version" "layer" {
  layer_name          = "test-layer"
  filename            = data.archive_file.layer.output_path
  source_code_hash    = data.archive_file.layer.output_base64sha256
}


resource "aws_lambda_function" "messages_lambda" {
  function_name = "messages_lambda-py"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.messages_lambda_s3.key

  runtime = "python3.11"
  handler = "handle_message.handler"

  source_code_hash = data.archive_file.messages_lambda_archive.output_base64sha256

  role = aws_iam_role.messages_lambda_iam_role.arn

  environment {
    variables = {
      MESSAGES_BUCKET = aws_s3_bucket.messages_bucket.id
    }
  }
}


resource "aws_s3_object" "messages_lambda_s3" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "messages.zip"
  source = data.archive_file.messages_lambda_archive.output_path

  source_hash = filemd5(data.archive_file.messages_lambda_archive.output_path)
}