output "elasticache_sg_id" {
  value = aws_security_group.elasticache_sg.id
}


output "elasticache_url" {
  value = var.single_node == true ? aws_elasticache_cluster.elasticache[0].primary_endpoint_address : [""]

}


output "elasticache_replica_url" {
  value = join(
    ",",
    aws_elasticache_replication_group.cerberus_redis.*.primary_endpoint_address,
  )
}


