#--------------------
# Subnet Groups
#--------------------
resource "aws_elasticache_subnet_group" "elasticache_private_subnet" {
  count       = "${var.elasticache_number_cache_clusters != 0 ? 1 : 0}"
  name        = "${var.elasticache_cluster_name}-private-subnet"
  subnet_ids  = ["${split(",", var.private_subnet_ids)}"]
  lifecycle {
    create_before_destroy = true
  }
}


#--------------------
# Params Group
#--------------------
resource "aws_elasticache_parameter_group" "elasticache_params" {
  count   = "${var.elasticache_params_group_name == "default.redis3.2" ? 0 : 1}"
  name    = "${var.elasticache_params_group_name}"
  family  = "${var.elasticache_engine_version}"
  lifecycle {
    create_before_destroy = true
  }
}


#--------------------
# Security Group
#--------------------
resource "aws_security_group" "elasticache_sg" {
  count       = "${var.elasticache_number_cache_clusters != 0 ? 1 : 0}"
  name        = "${var.elasticache_cluster_name}-sg"
  description = "${var.elasticache_cluster_name} ${var.elasticache_engine_name} ${var.env} secgroup"

  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    security_groups = ["${split(",", var.app_sg_ids)}"]
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.elasticache_cluster_name}-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}


#----------------------------
# Create ElastiCache Cluster
#----------------------------
resource "aws_elasticache_cluster" "elasticache" {
  count       = "${var.elasticache_number_cache_clusters == 1 ? 1 : 0}"

  cluster_id  = "${var.elasticache_cluster_name}"
  engine      = "${var.elasticache_engine_name}"
  node_type   = "${var.elasticache_instance_type}"
  port        = 6379
  num_cache_nodes       = 1
  parameter_group_name  = "${var.elasticache_params_group_name}"
  subnet_group_name     = "${var.elasticache_cluster_name}-private-subnet"
  security_group_ids    =  ["${aws_security_group.elasticache_sg.id}"]
  apply_immediately     = true
  availability_zone     = "${element(split(",", var.azs), 0)}"
  tags {
    Name          = "${var.elasticache_cluster_name}",
    Project       = "${var.project_name}",
    Type          = "${var.elasticache_engine_name}",
    Layer         = "${var.elasticache_engine_name}",
    Environment   = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}


#---------------------------
# Create Elasticache Replica
#---------------------------
resource "aws_elasticache_replication_group" "cerberus_redis" {
  count     = "${var.elasticache_number_cache_clusters >= 2 ? 1 : 0}"

  replication_group_id          = "${var.elasticache_cluster_name}"
  replication_group_description = "${var.elasticache_cluster_name} ${var.elasticache_engine_name}"
  engine    = "${var.elasticache_engine_name}"
  port      = 6379
  node_type = "${var.elasticache_instance_type}"
  number_cache_clusters = "${var.elasticache_number_cache_clusters}"
  parameter_group_name  = "${var.elasticache_params_group_name}"
  subnet_group_name     = "${var.elasticache_cluster_name}-private-subnet"
  security_group_ids    = ["${aws_security_group.elasticache_sg.id}"]
  apply_immediately     = true
  availability_zones    = "${split(",", var.azs)}"
  automatic_failover_enabled = true

  tags {
    Name          = "${var.elasticache_cluster_name}",
    Project       = "${var.project_name}",
    Type          = "${var.elasticache_engine_name}",
    Layer         = "${var.elasticache_engine_name}",
    Environment   = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
