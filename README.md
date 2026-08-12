# terraform-aws-msk

Terraform module to create an Amazon MSK (Managed Streaming for Apache Kafka) provisioned cluster with custom configuration, encryption, authentication and observability.

## Features

- Provisioned cluster with custom `aws_msk_configuration` (auto-create/delete topics, partitions, replication factor, min ISR, retention)
- Encryption at rest with KMS (accepts key ID, ARN or alias) and TLS in transit by default
- Client authentication: IAM (default), SASL/SCRAM and/or unauthenticated
- EBS provisioned throughput support for high-throughput workloads
- Prometheus open monitoring (JMX and Node exporters) and CloudWatch enhanced monitoring levels
- Broker logs to CloudWatch (always, with optional KMS encryption of the log group) plus optional Firehose and S3 destinations
- **Security group derived from the cluster's real configuration**: only the ports for enabled listeners are opened (no plaintext port on TLS-only clusters, no SCRAM/IAM ports when disabled, monitoring ports only with exporters on)
- Cross-field validations: brokers multiple of subnets, replication factor vs brokers, min ISR vs replication factor, SCRAM requires TLS, throughput ranges, log destination requirements

## Usage

```hcl
module "msk" {
  source = "github.com/orlando-mt/terraform-aws-msk?ref=v1.0.0"

  cluster_name  = "my-events"
  kafka_version = "3.8.x"

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnet_ids
  client_security_group_ids = [module.eks.node_security_group_id]

  kms_key_id = module.kms.key_arns["msk"]

  enable_iam_auth      = true
  enable_jmx_exporter  = true
  enable_node_exporter = true

  tags = {
    Project   = "my-project"
    ManagedBy = "terraform"
  }
}
```

> **Tip:** with IAM auth (default), clients connect to the `bootstrap_brokers_sasl_iam` endpoint on port 9098 using the [aws-msk-iam-auth](https://github.com/aws/aws-msk-iam-auth) library. Pairs with [terraform-aws-kms](https://github.com/orlando-mt/terraform-aws-kms) for the encryption key.

## Examples

- [Complete](./examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| aws | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_msk_cluster.this | resource |
| aws_msk_configuration.this | resource |
| aws_cloudwatch_log_group.this | resource |
| aws_security_group.this | resource |
| aws_vpc_security_group_ingress_rule.clients | resource |
| aws_vpc_security_group_egress_rule.all_outbound | resource |
| aws_kms_key.this | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the MSK cluster | `string` | n/a | yes |
| vpc_id | VPC ID | `string` | n/a | yes |
| subnet_ids | Subnets for brokers (2-3 AZs) | `list(string)` | n/a | yes |
| client_security_group_ids | Client SGs allowed to connect | `list(string)` | n/a | yes |
| kms_key_id | KMS key (ID, ARN or alias) | `string` | n/a | yes |
| kafka_version | Kafka version | `string` | `"3.8.x"` | no |
| broker_nodes | Broker count (multiple of subnets) | `number` | `3` | no |
| broker_instance_type | Broker instance type | `string` | `"kafka.m7g.large"` | no |
| broker_ebs_volume_size | EBS size per broker (GB) | `number` | `100` | no |
| ebs_throughput_enabled | Provisioned EBS throughput | `bool` | `false` | no |
| ebs_volume_throughput | Throughput MiB/s (250-2375) | `number` | `250` | no |
| public_access_type | DISABLED or SERVICE_PROVIDED_EIPS | `string` | `"DISABLED"` | no |
| encryption_client_broker | TLS, TLS_PLAINTEXT, PLAINTEXT | `string` | `"TLS"` | no |
| enable_iam_auth | IAM authentication | `bool` | `true` | no |
| enable_scram_auth | SASL/SCRAM authentication | `bool` | `false` | no |
| enable_unauthenticated_access | Unauthenticated access | `bool` | `false` | no |
| enhanced_monitoring | CloudWatch monitoring level | `string` | `"DEFAULT"` | no |
| enable_jmx_exporter | Prometheus JMX exporter | `bool` | `false` | no |
| enable_node_exporter | Prometheus Node exporter | `bool` | `false` | no |
| log_retention_days | CloudWatch retention (days) | `number` | `30` | no |
| cloudwatch_logs_kms_key_id | KMS key for the log group | `string` | `null` | no |
| firehose_logs_enabled / firehose_delivery_stream | Firehose logs | `bool` / `string` | `false` / `null` | no |
| s3_logs_enabled / s3_logs_bucket / s3_logs_prefix | S3 logs | `bool` / `string` | `false` / `null` | no |
| auto_create_topics_enable | Kafka auto.create.topics | `bool` | `true` | no |
| delete_topic_enable | Kafka delete.topic | `bool` | `true` | no |
| default_num_partitions | Kafka num.partitions | `number` | `3` | no |
| default_replication_factor | Kafka replication factor | `number` | `3` | no |
| min_insync_replicas | Kafka min ISR | `number` | `2` | no |
| kafka_log_retention_hours | Kafka log.retention.hours | `number` | `168` | no |
| tags | Tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name / cluster_arn | Cluster identity |
| bootstrap_brokers | Plaintext endpoints (TLS-only: empty) |
| bootstrap_brokers_tls | TLS endpoints (9094) |
| bootstrap_brokers_sasl_iam | IAM endpoints (9098) |
| bootstrap_brokers_sasl_scram | SCRAM endpoints (9096) |
| zookeeper_connect_string / _tls | Zookeeper endpoints |
| security_group_id | MSK security group |
| configuration_arn | MSK configuration ARN |
| current_version | Cluster version (for updates) |
| log_group_name | CloudWatch log group |
<!-- END_TF_DOCS -->

## License

MIT. See [LICENSE](./LICENSE).
