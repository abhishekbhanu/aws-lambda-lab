variable "region" {
  type = string
  default = "us-east-1"  
}

variable "accountid" {
  type = string
}

variable "lambda_function_name" {
  type = string
  default = "dailyquote_lambda_function"
}

variable "endpoint_path" {
    type = string
    default = "dailyquote"

}

