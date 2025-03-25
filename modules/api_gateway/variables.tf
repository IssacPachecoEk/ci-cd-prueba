variable "env_name" {
  type        = string
  description = "Nombre del ambiente"
}

variable "routes_api_endpoints" {
  type = list(object({
    path_name   = string
    method_path = string
  }))
  default     = [{ path_name = "/hola", method_path = "get" }]
  description = "Rutas de la api"
}

variable "invoke_arn" {
  type        = string
  description = "ARN de la lambda"
}

variable "name_lambda" {
  type        = string
  description = "name de la lambda"
}

# variable "domain_name" {
#   type        = string
#   description = "Nombre del dominio"
# }

# variable "arn_certificate" {
#   type        = string
#   description = "Nombre del dominio"
# }