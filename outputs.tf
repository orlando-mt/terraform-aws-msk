output "cluster_name" {
  description = "Name of the MSK cluster"
  value       = aws_msk_cluster.this.cluster_name
}

output "cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = aws_msk_cluster.this.arn
}

output "bootstrap_brokers" {
  description = "Plaintext connection host:port pairs (empty on TLS-only clusters)"
  value       = aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_sasl_iam" {
  description = "SASL/IAM connection host:port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_sasl_scram" {
  description = "SASL/SCRAM connection host:port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_scram
}

output "zookeeper_connect_string" {
  description = "Zookeeper connection string"
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "Zookeeper TLS connection string"
  value       = aws_msk_cluster.this.zookeeper_connect_string_tls
}

output "security_group_id" {
  description = "ID of the MSK security group"
  value       = aws_security_group.this.id
}

output "configuration_arn" {
  description = "ARN of the MSK configuration"
  value       = aws_msk_configuration.this.arn
}

output "current_version" {
  description = "Current version of the MSK cluster (needed for updates)"
  value       = aws_msk_cluster.this.current_version
}

output "log_group_name" {
  description = "CloudWatch log group for broker logs"
  value       = aws_cloudwatch_log_group.this.name
}
