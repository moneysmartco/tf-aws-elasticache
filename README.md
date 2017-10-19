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

- 0 will not create the resource.
- 1 will create a single instance of Elasticache
- > 2 will create a cluster with fail-over mode

If you set this to > 2 then you can't use cache.t2.xxx instance type.


