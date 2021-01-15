output "elasticache_sg_id" {
  value = aws_security_group.elasticache_sg.id
}

# Condition doesn't work here for condition ? 1 : 0
# Check later on the newer version

output "elasticache_url" {
  # value = "${aws_elasticache_cluster.elasticache.0.cache_nodes.0.address != "" ? aws_elasticache_cluster.elasticache.0.cache_nodes.0.address: "" }"
  value = "${var.single_node == true ? aws_elasticache_cluster.elasticache.0.cache_nodes.0.address : ""}"
}

# output "elasticache_url" {
#   value = aws_elasticache_cluster.elasticache.0.cache_nodes.0.address
# }

#output "elasticache_url" {
#   value = "${elasticache_number_cache_clusters >= 2 ? aws_elasticache_replication_group.cerberus_redis.primary_endpoint_address : aws_elasticache_cluster.elasticache.cache_nodes.0.address}"
#}


output "elasticache_replica_url" {
  value = join(
    ",",
    aws_elasticache_replication_group.cerberus_redis.*.primary_endpoint_address,
  )
}

#output "elasticache_url" {
#value = "${var.elasticache_number_cache_clusters == 1 ? join( ", ", aws_elasticache_cluster.elasticache.cache_nodes.*.address) : ""}"
#  value = "${var.elasticache_number_cache_clusters == 1 ? join( ", ", aws_elasticache_cluster.elasticache.*.cache_nodes.0.address) : ""}"
#}
