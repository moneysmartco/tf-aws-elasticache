output "elasticache_sg_id" {
  value = aws_security_group.elasticache_sg.id
}


output "elasticache_url" {
  value = var.single_node == true ? aws_elasticache_cluster.elasticache.*.cache_nodes.0.address : [""]

}


output "elasticache_replica_url" {
  value = join(
    ",",
    aws_elasticache_replication_group.cerberus_redis.*.primary_endpoint_address,
  )
}


