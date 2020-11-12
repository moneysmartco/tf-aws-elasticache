variable "env" {}
variable "azs" {}
variable "vpc_id" {}
variable "private_subnet_ids" {}
variable "project_name" {}

variable "app_sg_ids" {
  # type = "list"
  description = <<EOF
                It doesn't regconise the [${var1}, ${var2}] or $list(${var1}, ${var2})
                Please use "${var1},${$var2}"
                EOF
}

#--------------------------------
# ElastiCache
#--------------------------------
variable "elasticache_number_cache_clusters" {
  default = 1
}

variable "elasticache_cluster_name" {}

variable "elasticache_instance_type" {
  default = "cache.t2.micro"
}

variable "elasticache_engine_name" {
  default = "redis"
}

variable "elasticache_engine_version" {
  default = "5.0.4"
}

variable "elasticache_params_group_name" {
  description = "Exising parameters group to be used for the cluster. Using default if not specified."
  default     = "default.redis5.0"
}

variable "encryption_at_rest" {
  default = "true"
}


variable "tags" {
  description = "Tagging resources with default values"

  default = {
    "Name"        = ""
    "Country"     = ""
    "Environment" = ""
    "Repository"  = ""
    "Owner"       = ""
    "Department"  = ""
    "Team"        = "shared"
    "Product"     = "common"
    "Project"     = "common"
    "Stack"       = ""
  }
}

locals {
  # env tag in map structure
  env_tag = {
    Environment = "${var.env}"
  }

  # elasticache instance name tag in map structure
  elasticache_instance_name_tag = {
    Name = "${var.elasticache_cluster_name}"
  }

  # elasticache security group name tag in map structure
  elasticache_security_group_name_tag = {
    Name = "${var.elasticache_cluster_name}-${var.elasticache_engine_name}-rds-sg"
  }

  #------------------------------------------------------------
  # variables that will be mapped to the various resource block
  #------------------------------------------------------------

  aws_elasticache_instance_tags = "${merge(var.tags, local.env_tag, local.elasticache_instance_name_tag)}"
  aws_security_group_tags       = "${merge(var.tags, local.env_tag, local.elasticache_security_group_name_tag)}"
}
