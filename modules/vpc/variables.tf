variable "tags_vpc" {
  description = "etiquetas de las colas"
  nullable    = false
  type = object({
    Service        = string    
    environment    = string
    CostAllocation = string
    Terraform      = bool
  })
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "vpc_cidr" {
  type        = string
}

variable "subnets_cidr_public" {
  type    = list(string)
}

variable "subnets_cidr_private" {
  type    = list(string)
}

variable "azs" {
  description = "The availability zones to deploy the resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}