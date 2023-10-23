resource "aws_s3_bucket" "message_s3" {
  bucket = "message-lambda"

  tags = {
    Name = "message-lambda"

  }
}

