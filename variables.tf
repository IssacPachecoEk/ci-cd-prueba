# iam
variable "iam_role_services" {}
variable "name_policy" {}
variable "name_role" {}
variable "iam_resource_permission" {}
variable "iam_action_permission" {}
# lambda
variable "env_name" {}
variable "aws_lambda_function" {}
variable "retention_in_days" {}
variable "timeout" {}
variable "memory_size" {}
variable "ephemeral_storage_size" {}
variable "handler" {}
variable "runtime_version" {}
# vpc
variable "tags_vpc" {}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "subnets_cidr_public" {}
variable "subnets_cidr_private" {}
variable "azs" {}
# bucket
variable "bucket_name" {}
variable "bucket_versioning_enabled" {}
variable "bucket_block_public_acls" {}
variable "block_public_policy" {}
variable "ignore_public_acls" {}
variable "restrict_public_buckets" {}
variable "bucket_object_ownership" {}
# api gateway
variable "routes_api_endpoints" {}
# cloudfront
variable "comment" {}
variable "aliases" {}
variable "bucket_regional_domain_name" {}
variable "bucket_name" {}
variable "certificate_arn" {}
# dns 
variable "ttl_time" {}
variable "record_type" {}
variable "domain_name" {}
variable "subdomain_name" {}