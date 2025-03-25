variable "iam_action_permission" {
  description = "permisos de cada accion de los servicios de aws"
  type        = list(string)
  default     = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
  nullable    = false
}
variable "iam_resource_permission" {
  description = "Recursos a los que se les dara permisos"
  type        = string
  default     = "*"
  nullable    = false
}
variable "name_role" {
  description = "Nombre del rol"
  type        = string
  default     = "role_lambda_fraternitas"
  nullable    = false
}
variable "name_policy" {
  description = "Nombre de la politica"
  type        = string
  default     = "policy_lambda_fraternitas"
  nullable    = false
}
variable "iam_role_services" {
  description = "Servicios que pueden asumir el rol"
  type        = list(string)
  default     = ["apigateway.amazonaws.com","lambda.amazonaws.com"]
  nullable    = false
}