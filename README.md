# Elasticache Module

Create Redis single node replication cluster with encryption enabled

# Usage

```
module "test_sg_elasticache_cluster" {
  source = "github.com/moneysmartco/tf-aws-elasticache.git?ref=v.2.0.4"
  cluster_replication_enabled       = "${var.cluster_replication_enabled}" #true if encryption is required

  env                               = "${var.env}"
  azs                               = "${element(split(",", var.azs), length(var.test_sg_elasticache_number_cache_clusters))}"
  vpc_id                            = "${var.vpc_id}"
  private_subnet_ids                = "${var.private_subnet_ids}"
  project_name                      = "${var.project_name}"
  
  elasticache_number_cache_clusters = "${var.test_sg_elasticache_number_cache_clusters}"
  elasticache_params_group_name     = "${var.test_sg_elasticache_params_group_name}"
  elasticache_cluster_name          = "${var.test_sg_elasticache_cluster_name}"
  elasticache_instance_type         = "${var.test_sg_elasticache_instance_type}"
  elasticache_engine_name           = "${var.test_sg_elasticache_engine_name}"
  elasticache_engine_version        = "${var.test_sg_elasticache_engine_version}"
  
  app_sg_ids                        = "${var.elasticache_app_sg_ids != "" ? var.elasticache_app_sg_ids : data.terraform_remote_state.eks_foundation.worker_node_security_group_id }"
  snapshot_name                     = "" #optional, add only if required
  encryption_at_rest                = "${var.test_sg_encryption_at_rest}"
  automatic_failover_enabled        = "false"
}
```

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
Set `cluster_replication_enabled` to true to enable cluster mode
Set `single_node` to true, to disable cluster mode
Set `redis_number_cache_clusters` to

- 0 will not create the resource.
- 1 will create a single instance of Elasticache
- > 2 will create a cluster with fail-over mode

If you set this to > 2 then you can't use cache.t2.xxx instance type.


