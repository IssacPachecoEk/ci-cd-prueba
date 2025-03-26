variable "runtime_version" {
  type        = string
  description = "la version del runtimes"
}

variable "env_name" {
  type        = string
  description = "Nombre del ambiente"
}

variable "role_lambda_arn" {
  type        = string
  description = "El arn del rol"
}

variable "handler" {
  type        = string
  description = "El manejador de la lambda"
}

variable "ephemeral_storage_size" {
  type        = string
  description = "El tamaño del alamacenamiento efimero"
}

variable "memory_size" {
  type        = string
  description = "El tamaño de la memoria ram de la lambda"
}

variable "timeout" {
  type        = string
  description = "El tiempo de vida del lambda"
}

variable "retention_in_days" {
  type        = string
  description = "tiempo de rentencion de los logs"
}

# variable "subnets_for_lambda" {
#   type    = list(string)
# }
# variable "sg_for_lambda" {
#   type    = string
# }