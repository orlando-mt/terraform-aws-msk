# --- Cluster ---------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "kafka_version" {
  description = "Kafka version for the MSK cluster"
  type        = string
  default     = "3.8.x"
}

variable "broker_nodes" {
  description = "Number of broker nodes in the cluster (must be a multiple of the number of subnets)"
  type        = number
  default     = 3

  validation {
    condition     = var.broker_nodes % length(var.subnet_ids) == 0
    error_message = "broker_nodes must be a multiple of the number of subnets (AZs)."
  }
}

variable "enhanced_monitoring" {
  description = "CloudWatch monitoring level: DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER or PER_TOPIC_PER_PARTITION"
  type        = string
  default     = "DEFAULT"

  validation {
    condition     = contains(["DEFAULT", "PER_BROKER", "PER_TOPIC_PER_BROKER", "PER_TOPIC_PER_PARTITION"], var.enhanced_monitoring)
    error_message = "enhanced_monitoring must be DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER or PER_TOPIC_PER_PARTITION."
  }
}

# --- Brokers ---------------------------------------------------------------

variable "broker_instance_type" {
  description = "Instance type for Kafka brokers (e.g., kafka.m7g.large — Graviton3, ARM)"
  type        = string
  default     = "kafka.m7g.large"
}

variable "broker_ebs_volume_size" {
  description = "Size of the EBS volume for each broker in GB"
  type        = number
  default     = 100
}

variable "ebs_throughput_enabled" {
  description = "Enable provisioned throughput for EBS volumes (requires volume >= 10 GiB and supported instance types)"
  type        = bool
  default     = false
}

variable "ebs_volume_throughput" {
  description = "Provisioned throughput in MiB/s (250-2375, only when ebs_throughput_enabled)"
  type        = number
  default     = 250

  validation {
    condition     = !var.ebs_throughput_enabled || (var.ebs_volume_throughput >= 250 && var.ebs_volume_throughput <= 2375)
    error_message = "ebs_volume_throughput must be between 250 and 2375 MiB/s when provisioned throughput is enabled."
  }
}

# --- Networking ------------------------------------------------------------

variable "vpc_id" {
  description = "VPC ID where the MSK cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for broker nodes (2 or 3 AZs)"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2 && length(var.subnet_ids) <= 3
    error_message = "MSK requires between 2 and 3 subnets in different AZs."
  }
}

variable "client_security_group_ids" {
  description = "Security group IDs allowed to connect to MSK"
  type        = list(string)
}

variable "public_access_type" {
  description = "Public access type: DISABLED or SERVICE_PROVIDED_EIPS"
  type        = string
  default     = "DISABLED"

  validation {
    condition     = contains(["DISABLED", "SERVICE_PROVIDED_EIPS"], var.public_access_type)
    error_message = "public_access_type must be DISABLED or SERVICE_PROVIDED_EIPS."
  }
}

# --- Encryption ------------------------------------------------------------

variable "kms_key_id" {
  description = "KMS key ID, ARN or alias for encryption at rest"
  type        = string
}

variable "encryption_client_broker" {
  description = "Encryption in transit between clients and brokers: TLS, TLS_PLAINTEXT or PLAINTEXT"
  type        = string
  default     = "TLS"

  validation {
    condition     = contains(["TLS", "TLS_PLAINTEXT", "PLAINTEXT"], var.encryption_client_broker)
    error_message = "encryption_client_broker must be TLS, TLS_PLAINTEXT or PLAINTEXT."
  }
}

# --- Authentication --------------------------------------------------------

variable "enable_iam_auth" {
  description = "Enable IAM authentication"
  type        = bool
  default     = true
}

variable "enable_scram_auth" {
  description = "Enable SASL/SCRAM authentication (requires TLS between clients and brokers)"
  type        = bool
  default     = false

  validation {
    condition     = !var.enable_scram_auth || var.encryption_client_broker != "PLAINTEXT"
    error_message = "SASL/SCRAM requires TLS: encryption_client_broker cannot be PLAINTEXT."
  }
}

variable "enable_unauthenticated_access" {
  description = "Enable unauthenticated access (not recommended)"
  type        = bool
  default     = false
}

# --- Monitoring ------------------------------------------------------------

variable "enable_jmx_exporter" {
  description = "Enable the Prometheus JMX exporter on brokers (port 11001)"
  type        = bool
  default     = false
}

variable "enable_node_exporter" {
  description = "Enable the Prometheus Node exporter on brokers (port 11002)"
  type        = bool
  default     = false
}

# --- Logging ---------------------------------------------------------------

variable "log_retention_days" {
  description = "CloudWatch broker log retention in days (set 365+ where compliance requires it)"
  type        = number
  default     = 30
}

variable "cloudwatch_logs_kms_key_id" {
  description = "KMS key ARN to encrypt the CloudWatch log group. The key policy must grant usage to the logs.<region>.amazonaws.com service principal. If null, CloudWatch-managed encryption is used"
  type        = string
  default     = null
}

variable "firehose_logs_enabled" {
  description = "Enable broker logs to Kinesis Data Firehose"
  type        = bool
  default     = false
}

variable "firehose_delivery_stream" {
  description = "Kinesis Data Firehose delivery stream name (required if firehose_logs_enabled)"
  type        = string
  default     = null

  validation {
    condition     = !var.firehose_logs_enabled || (var.firehose_delivery_stream != null && var.firehose_delivery_stream != "")
    error_message = "firehose_delivery_stream is required when firehose_logs_enabled is true."
  }
}

variable "s3_logs_enabled" {
  description = "Enable broker logs to S3"
  type        = bool
  default     = false
}

variable "s3_logs_bucket" {
  description = "S3 bucket for broker logs (required if s3_logs_enabled)"
  type        = string
  default     = null

  validation {
    condition     = !var.s3_logs_enabled || (var.s3_logs_bucket != null && var.s3_logs_bucket != "")
    error_message = "s3_logs_bucket is required when s3_logs_enabled is true."
  }
}

variable "s3_logs_prefix" {
  description = "S3 prefix for broker logs"
  type        = string
  default     = null
}

# --- Kafka server properties -----------------------------------------------

variable "auto_create_topics_enable" {
  description = "Enable automatic topic creation"
  type        = bool
  default     = true
}

variable "delete_topic_enable" {
  description = "Enable topic deletion"
  type        = bool
  default     = true
}

variable "default_num_partitions" {
  description = "Default number of partitions per topic"
  type        = number
  default     = 3
}

variable "default_replication_factor" {
  description = "Default replication factor (cannot exceed the number of brokers)"
  type        = number
  default     = 3

  validation {
    condition     = var.default_replication_factor <= var.broker_nodes
    error_message = "default_replication_factor cannot exceed broker_nodes."
  }
}

variable "min_insync_replicas" {
  description = "Minimum in-sync replicas (must be <= default_replication_factor)"
  type        = number
  default     = 2

  validation {
    condition     = var.min_insync_replicas <= var.default_replication_factor
    error_message = "min_insync_replicas must be <= default_replication_factor."
  }
}

variable "kafka_log_retention_hours" {
  description = "Kafka topic log retention in hours (default 168 = 7 days)"
  type        = number
  default     = 168
}

# --- Tags ------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
