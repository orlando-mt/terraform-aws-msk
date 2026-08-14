region        = "us-east-1"
cluster_name  = "example-events"
kafka_version = "3.8.x"

vpc_id                    = "vpc-00000000000000000"
subnet_ids                = ["subnet-00000000000000001", "subnet-00000000000000002", "subnet-00000000000000003"]
client_security_group_ids = ["sg-00000000000000000"]

broker_nodes           = 3
broker_instance_type   = "kafka.m7g.large"
broker_ebs_volume_size = 100

# Encryption at rest (key ID, ARN or alias)
kms_key_id               = "alias/example-msk"
encryption_client_broker = "TLS"

# IAM authentication only
enable_iam_auth   = true
enable_scram_auth = false

# Prometheus monitoring
enable_jmx_exporter  = true
enable_node_exporter = true

default_num_partitions     = 6
default_replication_factor = 3
min_insync_replicas        = 2

tags = {
  Project   = "example"
  ManagedBy = "terraform"
}
