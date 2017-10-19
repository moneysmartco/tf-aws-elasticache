# Elasticache Module

Create single node for ElastiCache Redis or Memcached

# Usage

```
module "redis" {
  source = "git@github.com:moneysmartco/tf-aws-elasticache.git?ref=v1.x"
  env                = "${var.env}"
  azs                = "${var.azs}"
  vpc_id             = "${var.vpc_id}"
  private_subnet_ids = "${var.private_subnet_ids}"
  project_name       = "${var.app_name}"
  app_sg_ids         = "${var.app_sg_id}"
  elasticache_cluster_name          = "${var.redis_cluster_name}"
  elasticache_instance_type         = "${var.redis_instance_type} | cache.t2.micro"
  elasticache_number_cache_clusters = "${var.redis_number_cache_clusters}"
}
```

Set `redis_number_cache_clusters` to

- 0 if you don't want to create the Elastiache
- 1 if you only want to create 1 Elasticache
- 2 or more if you want to create a failover cluster (You can't use cache.t2.xxx for instance_type)

