# Changelog

## [1.0.0] - 2026-07-30

### Added
- Initial release: MSK provisioned cluster with custom configuration
  (topics, partitions, replication, retention)
- Encryption at rest (KMS) and in transit (TLS by default)
- IAM / SASL-SCRAM / unauthenticated client authentication toggles
- EBS provisioned throughput support
- Prometheus open monitoring (JMX / Node exporters) and enhanced
  monitoring levels
- Broker logs to CloudWatch (always), Firehose and S3 (optional)
- Security group with conditional per-listener ingress rules derived
  from the actual cluster configuration
- Cross-field validations (brokers vs subnets, replication factor,
  SCRAM requires TLS, throughput ranges, log destinations)
