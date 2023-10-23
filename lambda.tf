resource "aws_lambda_function" "put_s3" {
 
 filename = "${path.module}/python/lambdaPutS3.zip"
 function_name = "lambdaPutS3"
  runtime = "python3.11"
  handler = "lambdaPutS3.lambda_handler"
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "lambda_put_s3" {
  name = "/aws/lambda/${aws_lambda_function.put_s3.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_iam_policy" "iam_policy_for_lambda_s3" {

  name         = "aws_iam_policy_for_terraform_aws_lambda_s3"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::message-lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_lambda_s3" {
  role        = aws_iam_role.lambda_exec.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda_s3.arn
}

# resource "aws_lambda_permission" "api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.terraform_lambda_func.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.hello-api.execution_arn}/*/*/post"
# }
