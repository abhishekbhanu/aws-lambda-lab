resource "aws_api_gateway_rest_api" "dailyquote_api" {  
  name = "dailyquote_api"
}

resource "aws_api_gateway_resource" "dailyquote_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.dailyquote_api.id
  parent_id = aws_api_gateway_rest_api.dailyquote_api.root_resource_id
  path_part = var.endpoint_path  
}

resource "aws_api_gateway_method" "dailyquote_api_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.dailyquote_api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.dailyquote_api.id
}

resource "aws_api_gateway_integration" "dailyquote_api_integration" {
  http_method = aws_api_gateway_method.dailyquote_api_method.http_method
  resource_id = aws_api_gateway_resource.dailyquote_api_resource.id
  rest_api_id = aws_api_gateway_rest_api.dailyquote_api.id
  integration_http_method = "POST"
  uri = aws_lambda_function.dailyquote.invoke_arn
  type        = "AWS_PROXY"
}

resource "aws_api_gateway_deployment" "dailyquote_deployment" {
  depends_on = [
    aws_api_gateway_integration.dailyquote_api_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.dailyquote_api.id
  stage_name  = "dev"
  triggers = {
    redepolyment =sha1(jsonencode(aws_api_gateway_rest_api.dailyquote_api.body))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "invoke_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dailyquote.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountid}:${aws_api_gateway_rest_api.dailyquote_api.id}/*/${aws_api_gateway_method.dailyquote_api_method.http_method}${aws_api_gateway_resource.dailyquote_api_resource.path}"
}

resource "aws_api_gateway_stage" "dailyquote_stage" {
  deployment_id = aws_api_gateway_deployment.dailyquote_deployment.id
  rest_api_id = aws_api_gateway_rest_api.dailyquote_api.id
  stage_name = "DEV"
  lifecycle {
    create_before_destroy = false
  }
}