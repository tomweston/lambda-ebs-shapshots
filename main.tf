resource "aws_iam_role" "ebs_snapshot_generator_role" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "ebs_snapshot_generator" {
  filename         = "ebs_snapshot_generator.zip"
  function_name    = "la-${var.region}-${env}-ebs-snapshot-generator"
  role             = "${aws_iam_role.ebs_snapshot_generator_role.arn}"
  handler          = "index.lambda_handler"
  source_code_hash = "${base64sha256(file("ebs_snapshot_generator.zip"))}"
  runtime          = "python3"
}
