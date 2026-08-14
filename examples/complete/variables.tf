variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "kafka_version" {
  description = "Kafka version"
  type        = string
  default     = "3.8.x"
}

variable "vpc_id" {
  description = "VPC for the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets (2-3 AZs)"
  type        = list(string)
}

variable "client_security_group_ids" {
  description = "Security groups allowed to connect"
  type        = list(string)
}

variable "kms_key_id" {
  description = "KMS key for encryption at rest"
  type        = string
}

variable "broker_nodes" {
  description = "Number of brokers"
  type        = number
  default     = 3
}

variable "broker_instance_type" {
  description = "Broker instance type"
  type        = string
  default     = "kafka.m7g.large"
}

variable "broker_ebs_volume_size" {
  description = "EBS size per broker in GB"
  type        = number
  default     = 100
}

variable "encryption_client_broker" {
  description = "Client-broker encryption: TLS, TLS_PLAINTEXT or PLAINTEXT"
  type        = string
  default     = "TLS"
}

variable "enable_iam_auth" {
  description = "Enable IAM authentication"
  type        = bool
  default     = true
}

variable "enable_scram_auth" {
  description = "Enable SASL/SCRAM authentication"
  type        = bool
  default     = false
}

variable "enable_jmx_exporter" {
  description = "Enable the Prometheus JMX exporter"
  type        = bool
  default     = false
}

variable "enable_node_exporter" {
  description = "Enable the Prometheus Node exporter"
  type        = bool
  default     = false
}

variable "default_num_partitions" {
  description = "Default partitions per topic"
  type        = number
  default     = 3
}

variable "default_replication_factor" {
  description = "Default replication factor"
  type        = number
  default     = 3
}

variable "min_insync_replicas" {
  description = "Minimum in-sync replicas"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
