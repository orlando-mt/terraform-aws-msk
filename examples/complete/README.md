# Complete example

Creates a 3-broker MSK cluster with:

- TLS-only client traffic and IAM authentication
- KMS encryption at rest
- Prometheus JMX/Node exporters enabled
- 6 default partitions, replication factor 3, min ISR 2

## Usage

```bash
terraform init
terraform apply \
  -var "vpc_id=vpc-xxxx" \
  -var 'private_subnet_ids=["subnet-a","subnet-b","subnet-c"]' \
  -var "app_security_group_id=sg-cccc" \
  -var "kms_key_id=alias/my-msk-key"
```
