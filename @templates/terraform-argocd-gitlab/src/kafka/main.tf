terraform {
  backend "http" {
  }
}

provider "kafka" {
  bootstrap_servers = [var.kafka_urls.default.dev]
  skip_tls_verify   = true
  alias             = "kafka-dev"
}

provider "kafka" {
  bootstrap_servers = [var.kafka_urls.default.rci]
  skip_tls_verify   = true
  alias             = "kafka-rci"
}

provider "kafka" {
  bootstrap_servers = [var.kafka_urls.default.preprod]
  skip_tls_verify   = true
  alias             = "kafka-preprod"
}

provider "kafka" {
  bootstrap_servers = [var.kafka_urls.default.rcc]
  skip_tls_verify   = true
  alias             = "kafka-rcc"
}

provider "kafka" {
  bootstrap_servers = [var.kafka_urls.default.prod]
  skip_tls_verify   = true
  alias             = "kafka-prod"
}

locals {
  default_topic_config = {
    "cleanup.policy"      = "delete"
    "min.insync.replicas" = "2"
    "retention.ms"        = "604800000" # 7 days
    "retention.bytes"     = -1
  }
  deadletter_topic_config = merge(local.default_topic_config, {
    "retention.ms" = "2419200000" # 1 month
  })
}
