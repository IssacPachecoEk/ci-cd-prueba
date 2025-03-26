variable "env_name" {
  type        = string
  description = "Nombre del ambiente"
}

variable "invoke_arn" {
  type        = string
  description = "ARN de la lambda"
}

variable "name_lambda" {
  type        = string
  description = "name de la lambda"
}

variable "aws_region" {
  type        = string
  description = "region del api gateway"
}

# variable "domain_name" {
#   type        = string
#   description = "Nombre del dominio"
# }

# variable "arn_certificate" {
#   type        = string
#   description = "Nombre del dominio"
# }