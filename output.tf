output "endpoint_url" {
  value = "${aws_api_gateway_stage.dailyquote_stage.invoke_url}/${var.endpoint_path}"
}