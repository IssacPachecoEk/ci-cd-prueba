terraform {
  backend "s3" {
    bucket = ""
    key    = "automatizacion-devops-terraform/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.92.0"
    }
  }
  required_version = "~>1.10.5"
}

provider "aws" {
  region = local.region["virginia"]
  alias  = "virginia"
  default_tags {
    tags = local.common_tag
  }
}

# provider "random" {}

# resource "random_string" "bucket_suffix" {
#   length  = 4
#   special = false
#   upper   = false
# }

# module "vpc" {
#   source               = "./modules/vpc"
#   vpc_name             = var.vpc_name
#   vpc_cidr             = var.vpc_cidr
#   subnets_cidr_public  = var.subnets_cidr_public
#   subnets_cidr_private = var.subnets_cidr_private
#   azs                  = var.azs
#   app                  = var.app
#   tags_vpc = {
#     environment    = local.env_name
#     Service        = "vpc"
#     Terraform      = "true"
#     CostAllocation = format("%s-%s", var.app, local.env_name)
#   }
# }

module "iam" {
  source                  = "./modules/iam"
  name_role               = var.name_role
}

module "lambda" {
  source                 = "./modules/lambda"
  env_name               = var.env_name
  role_lambda_arn        = module.iam.arn_role_lambda_fraternitas
  runtime_version        = var.runtime_version
  handler                = var.handler
  ephemeral_storage_size = var.ephemeral_storage_size
  memory_size            = var.memory_size
  timeout                = var.timeout
  retention_in_days      = var.retention_in_days
  depends_on             = [module.iam]
  # subnets_for_lambda     = module.vpc.vpc_subnets_private_ids
  # sg_for_lambda          = module.vpc.sg
}

# module "bucket" {
#   source                    = "./modules/s3"
#   bucket_name               = var.bucket_name
#   bucket_versioning_enabled = var.bucket_versioning_enabled
#   bucket_block_public_acls  = var.bucket_block_public_acls
#   block_public_policy       = var.block_public_policy
#   ignore_public_acls        = var.ignore_public_acls
#   restrict_public_buckets   = var.restrict_public_buckets
#   bucket_object_ownership   = var.bucket_object_ownership
#   common_tag                = local.common_tag
# }

module "api_gateway" {
  source               = "./modules/api_gateway"
  env_name             = var.env_name
  invoke_arn           = module.lambda.output_arn_lambda_fraternitas
  name_lambda          = module.lambda.output_name_lambda_fraternitas
  aws_region           = local.region["virginia"]
  depends_on           = [module.lambda]
  # domain_name          = var.domain_name
  # arn_certificate      = module.dns.aws_acm_certificate.cert.arn
}

# module "cloudfront" {
#   source                      = "./modules/cloudfront"
#   comment                     = var.comment
#   aliases                     = var.aliases
#   bucket_regional_domain_name = var.bucket_regional_domain_name
#   bucket_name                 = var.bucket_name
#   certificate_arn             = var.certificate_arn
# }

# module "dns" {
#   source         = "./modules/route_53"
#   ttl_time       = var.ttl_time
#   record_type    = var.record_type
#   domain_name    = var.domain_name
#   subdomain_name = var.subdomain_name
# }