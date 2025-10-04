resource "aws_lambda_function" "authorizer" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "api-authorizer"
  role             = data.aws_iam_role.lab_role.arn
  handler          = "lambda_authorizer.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TOKEN = aws_ssm_parameter.valid_token_ssm.value
    }
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "eks-proxy-api"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_auth.id
}

resource "aws_api_gateway_authorizer" "lambda_auth" {
  name                   = "eks-lambda-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_result_ttl_in_seconds = 300
  identity_source        = "method.request.header.Authorization"
  type                   = "TOKEN"
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${data.kubernetes_service.app_loadbalancer_service.status[0].load_balancer[0].ingress[0].hostname}/{proxy}"
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [aws_api_gateway_integration.proxy]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_lambda_permission" "apigw_authorizer_invoke" {
  statement_id  = "AllowAPIGatewayInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/authorizers/*"
}

resource "random_password" "valid_token" {
  length  = 16
  special = true
}

resource "aws_ssm_parameter" "valid_token_ssm" {
  name        = "/ordering-system/apigateway/token"
  description = "Valid token for integration"
  type        = "SecureString"
  value       = random_password.valid_token.result
}
