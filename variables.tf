variable "env"                      {}  
variable "azs"                      {}
variable "vpc_id"                   {}  
variable "private_subnet_ids"       {}
variable "project_name"             {}
variable "app_sg_ids"               {
  # type = "list"
  description = <<EOF
                It doesn't regconise the [${var1}, ${var2}] or $list(${var1}, ${var2})
                Please use "${var1},${$var2}"
                EOF
}
variable "elasticache_params_group_name"  {
  default = "default.redis3.2"
}
variable "elasticache_cluster_name"       {}
variable "elasticache_instance_type"      {
  default = "cache.t2.micro"
}
variable "elasticache_engine_name"        {
  default = "redis"
}
variable "elasticache_engine_version"     {
  default = "redis3.2"
}
variable "elasticache_number_cache_clusters" {
  description = <<EOF
                Use this to specify the number of Elasticache instances.
                - 0 will not create the resource.
                - 1 will create a single instance of Elasticache
                - > 2 will create a cluster with fail-over mode
                If you set this to > 2 then you can't use cache.t2.xxx instance type.
                EOF
  default     = 0 
}
