locals {
  plaintext_enabled = contains(["PLAINTEXT", "TLS_PLAINTEXT"], var.encryption_client_broker)

  # Listener ports opened according to the cluster's actual configuration:
  # no PLAINTEXT port on TLS-only clusters, no SCRAM/IAM ports when those
  # auth methods are disabled, monitoring ports only with exporters enabled.
  listener_ports = merge(
    local.plaintext_enabled ? { 9092 = "Kafka plaintext" } : {},
    { 9094 = "Kafka TLS" },
    var.enable_scram_auth ? { 9096 = "Kafka SASL/SCRAM" } : {},
    var.enable_iam_auth ? { 9098 = "Kafka SASL/IAM" } : {},
    { 2181 = "Zookeeper" },
    { 2182 = "Zookeeper TLS" },
    var.enable_jmx_exporter ? { 11001 = "JMX Exporter" } : {},
    var.enable_node_exporter ? { 11002 = "Node Exporter" } : {}
  )

  ingress_rules = {
    for pair in setproduct(keys(local.listener_ports), var.client_security_group_ids) :
    "${pair[0]}-${pair[1]}" => {
      port        = tonumber(pair[0])
      description = local.listener_ports[tonumber(pair[0])]
      source_sg   = pair[1]
    }
  }
}

resource "aws_security_group" "this" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for MSK cluster ${var.cluster_name}"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "clients" {
  for_each = local.ingress_rules

  security_group_id            = aws_security_group.this.id
  description                  = "${each.value.description} from ${each.value.source_sg}"
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value.source_sg

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = var.tags
}
