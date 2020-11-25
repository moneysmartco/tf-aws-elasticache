#--------------------
# Subnet Groups
#--------------------
resource "aws_elasticache_subnet_group" "elasticache_private_subnet" {
  name       = "${var.elasticache_cluster_name}-private-subnet"
  subnet_ids = ["${split(",", var.private_subnet_ids)}"]

  lifecycle {
    create_before_destroy = true
  }
}

#--------------------
# Security Group
#--------------------
resource "aws_security_group" "elasticache_sg" {
  name        = "${var.elasticache_cluster_name}-sg"
  description = "${var.elasticache_cluster_name} ${var.elasticache_engine_name} ${var.env} secgroup"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${split(",", var.app_sg_ids)}"]
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.aws_security_group_tags}"

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------
# Create ElastiCache Cluster
#----------------------------

resource "aws_elasticache_cluster" "elasticache" {
  count = "${var.single_node ? 1 : 0}"

  #20 characters max
  cluster_id      = "${replace(format("%s", var.elasticache_cluster_name), "/(.{0,20})(.*)/", "$1")}"
  node_type       = "${var.elasticache_instance_type}"
  num_cache_nodes = 1

  engine         = "${var.elasticache_engine_name}"
  engine_version = "${var.elasticache_engine_version}"

  port               = 6379
  availability_zone  = "${element(split(",", var.azs), 0)}"
  subnet_group_name  = "${aws_elasticache_subnet_group.elasticache_private_subnet.name}"
  security_group_ids = ["${aws_security_group.elasticache_sg.id}"]

  parameter_group_name = "${var.elasticache_params_group_name}"
  apply_immediately    = true

  tags = "${local.aws_elasticache_instance_tags}"

  lifecycle {
    create_before_destroy = true
 }
}

#---------------------------
# Create Elasticache Replica
#---------------------------
resource "aws_elasticache_replication_group" "cerberus_redis" {
  count = "${var.cluster_replication_enabled ? 1 : 0}"

  replication_group_id          = "${var.elasticache_cluster_name}"
  replication_group_description = "${var.elasticache_cluster_name} ${var.elasticache_engine_name}"
  node_type                     = "${var.elasticache_instance_type}"
  number_cache_clusters         = "${var.elasticache_number_cache_clusters}"

  engine         = "${var.elasticache_engine_name}"
  engine_version = "${var.elasticache_engine_version}"

  port               = 6379
  availability_zones = "${split(",", var.azs)}"
  subnet_group_name  = "${aws_elasticache_subnet_group.elasticache_private_subnet.name}"
  security_group_ids = ["${aws_security_group.elasticache_sg.id}"]

  parameter_group_name       = "${var.elasticache_params_group_name}"
  apply_immediately          = true
  automatic_failover_enabled = true
  at_rest_encryption_enabled = "${var.encryption_at_rest}"

  tags = "${local.aws_elasticache_instance_tags}"

  lifecycle {
    create_before_destroy = true
  }
}
