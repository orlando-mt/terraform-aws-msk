output "bootstrap_brokers_sasl_iam" {
  description = "IAM bootstrap brokers for client configuration"
  value       = module.msk.bootstrap_brokers_sasl_iam
}

output "cluster_arn" {
  description = "Cluster ARN"
  value       = module.msk.cluster_arn
}
