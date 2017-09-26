variable "env"                      {}  
variable "azs"                      {}
variable "vpc_id"                   {}  
variable "private_subnet_ids"       {}
variable "project_name"             {}
# It doesn't regconise the [${var1}, ${var2}] or $list(${var1}, ${var2})
variable "app_sg_ids"               {
  # type = "list"
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
                Set this to create a replicaset. Smallest value is 2.
                Otherwise it will create a normal cluster with single elasticache instance
                Also nee at least m3.medium to use replicaset failover
                EOF
  default     = 0 
}