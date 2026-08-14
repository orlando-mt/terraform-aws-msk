# Complete example

Creates a 3-broker MSK cluster with:

- TLS-only client traffic and IAM authentication
- KMS encryption at rest
- Prometheus JMX/Node exporters enabled
- 6 default partitions, replication factor 3, min ISR 2

Replace the placeholder IDs in [`terraform.tfvars`](./terraform.tfvars) with
resources from your account before applying.

## Usage

```bash
terraform init
terraform plan
terraform apply
```
