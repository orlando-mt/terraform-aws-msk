data "aws_kms_key" "this" {
  key_id = var.kms_key_id
}

resource "aws_cloudwatch_log_group" "this" {
  # checkov:skip=CKV_AWS_338:Retention is configurable via log_retention_days; the 30-day default balances cost for operational broker logs (not audit logs). Set 365+ where compliance requires it.
  name              = "/msk/${var.cluster_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id
  tags              = var.tags
}

resource "aws_msk_configuration" "this" {
  name        = "${var.cluster_name}-config"
  description = "MSK Configuration for ${var.cluster_name}"

  server_properties = <<-PROPERTIES
    auto.create.topics.enable = ${var.auto_create_topics_enable}
    delete.topic.enable = ${var.delete_topic_enable}
    num.partitions = ${var.default_num_partitions}
    default.replication.factor = ${var.default_replication_factor}
    min.insync.replicas = ${var.min_insync_replicas}
    log.retention.hours = ${var.kafka_log_retention_hours}
  PROPERTIES
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = aws_msk_configuration.this.latest_revision
  }

  broker_node_group_info {
    client_subnets  = var.subnet_ids
    instance_type   = var.broker_instance_type
    security_groups = [aws_security_group.this.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_ebs_volume_size

        dynamic "provisioned_throughput" {
          for_each = var.ebs_throughput_enabled ? [1] : []
          content {
            enabled           = true
            volume_throughput = var.ebs_volume_throughput
          }
        }
      }
    }

    connectivity_info {
      public_access {
        type = var.public_access_type
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = data.aws_kms_key.this.arn

    encryption_in_transit {
      client_broker = var.encryption_client_broker
      in_cluster    = true
    }
  }

  client_authentication {
    sasl {
      iam   = var.enable_iam_auth
      scram = var.enable_scram_auth
    }

    unauthenticated = var.enable_unauthenticated_access
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.enable_jmx_exporter
      }
      node_exporter {
        enabled_in_broker = var.enable_node_exporter
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.this.name
      }

      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_logs_enabled ? var.firehose_delivery_stream : null
      }

      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_enabled ? var.s3_logs_bucket : null
        prefix  = var.s3_logs_enabled ? var.s3_logs_prefix : null
      }
    }
  }

  tags = var.tags
}
