variable "comment" {}

variable "domain_name" {}

variable "aliases" {}

variable "zone_id_domain" {}

variable "bucket_name" {}

variable "tags" {}

variable "bucket_regional_domain_name" {}

variable "certificate_arn" {
  type = string
}

variable "web_acl_id" {
  default = ""
}