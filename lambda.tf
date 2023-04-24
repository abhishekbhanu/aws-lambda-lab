
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "dailyquote_package.zip"
}
resource "aws_lambda_function" "dailyquote" {
    function_name =   var.lambda_function_name
    runtime = "python3.10"
    handler = "lambda_function.lambda_handler"
    role = aws_iam_role.lambda_exec_role.arn
    filename = "dailyquote_package.zip"
    source_code_hash = data.archive_file.lambda.output_base64sha256
}

resource "aws_iam_role" "lambda_exec_role" {
    name =   "lambda_exec_role"
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