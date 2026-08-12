provider "aws" {
  region = var.region
}

module "msk" {
  source = "../../"

  cluster_name  = "example-events"
  kafka_version = "3.8.x"

  vpc_id                    = var.vpc_id
  subnet_ids                = var.private_subnet_ids
  client_security_group_ids = [var.app_security_group_id]

  broker_nodes           = 3
  broker_instance_type   = "kafka.m7g.large"
  broker_ebs_volume_size = 100

  # Encryption
  kms_key_id               = var.kms_key_id
  encryption_client_broker = "TLS"

  # Auth: IAM only
  enable_iam_auth   = true
  enable_scram_auth = false

  # Prometheus monitoring
  enable_jmx_exporter  = true
  enable_node_exporter = true

  # Kafka defaults
  default_num_partitions     = 6
  default_replication_factor = 3
  min_insync_replicas        = 2

  tags = {
    Project   = "example"
    ManagedBy = "terraform"
  }
}
