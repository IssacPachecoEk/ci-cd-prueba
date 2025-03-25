resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.name_lambda
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.APIFraternitas.execution_arn}/*/*"
  depends_on = [aws_api_gateway_rest_api.APIFraternitas]
}

resource "aws_api_gateway_rest_api" "APIFraternitas" {
  name        = "api-backend-fraternitas-${var.env_name}"
  description = "API para invocar la lambda fraternitas"
  tags = {
    Environment = var.env_name
    Name        = "API-backend"
    Terraform   = "true"
  }
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "APIFraternitas"
      version = "1.0"
    }
    paths = local.routes_api_endpoints_map
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.APIFraternitas.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage_api" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.APIFraternitas.id
  stage_name    = "api"
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
  stage_name  = aws_api_gateway_stage.stage_api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

output "api_url" {
  value = "https://${aws_api_gateway_rest_api.APIFraternitas.id}.execute-api.us-east-1.amazonaws.com/api"
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name     = var.domain_name
  certificate_arn = var.arn_certificate
}

resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
  rest_api_id = aws_api_gateway_rest_api.APIFraternitas.id
  stage_name  = aws_api_gateway_stage.stage_api.stage_name
}
