provider "aws" {
  region = var.region
}

module "msk" {
  source = "../../"

  cluster_name  = var.cluster_name
  kafka_version = var.kafka_version

  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  client_security_group_ids = var.client_security_group_ids

  broker_nodes           = var.broker_nodes
  broker_instance_type   = var.broker_instance_type
  broker_ebs_volume_size = var.broker_ebs_volume_size

  kms_key_id               = var.kms_key_id
  encryption_client_broker = var.encryption_client_broker

  enable_iam_auth   = var.enable_iam_auth
  enable_scram_auth = var.enable_scram_auth

  enable_jmx_exporter  = var.enable_jmx_exporter
  enable_node_exporter = var.enable_node_exporter

  default_num_partitions     = var.default_num_partitions
  default_replication_factor = var.default_replication_factor
  min_insync_replicas        = var.min_insync_replicas

  tags = var.tags
}
