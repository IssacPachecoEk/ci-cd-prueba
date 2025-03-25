locals {
  routes_api_endpoints_map = {
    for route in var.routes_api_endpoints :
    route.path_name => {
      "${route.method_path}" = {
        x-amazon-apigateway-integration = {
          httpMethod           = route.method_path
          payloadFormatVersion = "1.0"
          type                 = "AWS_PROXY"
          uri                  = var.invoke_arn
          authorization        = "NONE"
        }
      }
    }
  }
}