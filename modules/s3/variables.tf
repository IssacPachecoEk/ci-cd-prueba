variable "bucket_name" {
  description = "Nombre del bucket"
  type        = string
  nullable    = false
}
variable "bucket_versioning_enabled" {
  description = "Estado del versionamiento del bucket"
  type        = string
  default     = "Enabled"
  nullable    = false
}
variable "bucket_block_public_acls" {
  description = "Estado del acceso publico del bucket"
  type        = bool
  default     = true
  nullable    = false
}
variable "bucket_block_public_policy" {
  description = "Estado de la politica publica del bucket"
  type        = bool
  default     = true
  nullable    = false
}
variable "bucket_ignore_public_acls" {
  description = "Estado para ignorar acl publicas del bucket"
  type        = bool
  default     = true
  nullable    = false
}
variable "bucket_restrict_public_buckets" {
  description = "Estado para restringir que sea publico el bucket"
  type        = bool
  default     = true
  nullable    = false
}
variable "bucket_object_ownership" {
  description = "El tipo de propietario del bucket"
  type        = string
  default     = "BucketOwnerPreferred"
  nullable    = false
}
variable "path_object" {
  description = "nombre del archivo dentro del s3"
  type        = string
  default     = "../../modules"
  nullable    = false
}
variable "source_object" {
  description = "fuente del archivo a subir"
  type        = string
  default     = "**/*.*"
  nullable    = false
}
variable "common_tag" {
  description = "etiquetas generales del despliegue"
  nullable    = false
  type = object({
    project     = string
    environment = string
    version     = string
  })
  default = {
    project     = "devops_prueba_fraternitas"
    environment = "dev"
    version = "1.0.0"
  }
}