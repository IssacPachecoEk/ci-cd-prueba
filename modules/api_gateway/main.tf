resource "aws_api_gateway_rest_api" "APIFraternitas" {
  name        = "api-backend-fraternitas-${var.env_name}"
  description = "API para invocar la lambda fraternitas"
}

resource "aws_api_gateway_resource" "APIFraternitas_resource" {
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
  parent_id   = aws_api_gateway_rest_api.APIFraternitas.root_resource_id
  path_part   = "hola"
}

resource "aws_api_gateway_method" "APIFraternitas_method" {
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
  resource_id = aws_api_gateway_resource.APIFraternitas_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "APIFraternitas_integration" {
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
  resource_id = aws_api_gateway_resource.APIFraternitas_resource.id
  http_method = aws_api_gateway_method.APIFraternitas_method.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = var.invoke_arn
}

resource "aws_api_gateway_deployment" "APIFraternitas_deployment" {
  depends_on = [aws_api_gateway_integration.APIFraternitas_integration]
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
}

resource "aws_api_gateway_stage" "APIFraternitas_stage" {
  deployment_id = aws_api_gateway_deployment.APIFraternitas_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.APIFraternitas.id
  stage_name    = "api"
}

resource "aws_lambda_permission" "APIFraternitas_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.name_lambda
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.APIFraternitas.execution_arn}/*/*"
}

output "api_url" {
  value = "${aws_api_gateway_stage.APIFraternitas_stage.invoke_url}/hola"
}

# resource "aws_api_gateway_domain_name" "custom_domain" {
#   domain_name     = var.domain_name
#   certificate_arn = var.arn_certificate
# }

# resource "aws_api_gateway_base_path_mapping" "path_mapping" {
#   domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
#   rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
#   stage_name  = aws_api_gateway_stage.stage_api.stage_name
# }
