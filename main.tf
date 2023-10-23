data "archive_file" "lambda_s3_put" {
  type = "zip"

  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/lambdaPutS3.zip"
}