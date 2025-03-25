variable "domain_name" {
  type        = string
  description = "nombre del dominio"
}

variable "subdomain_name" {
  type        = string
  description = "nombre del subdominio"
}

variable "record_type" {
  type        = string
  description = "el tipo de registro"
}

variable "ttl_time" {
  type        = string
  description = "el tiempo del registro"
}