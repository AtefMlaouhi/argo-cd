resource "kafka_topic" "dev-topicname-v1" {
  name               = "dev-topicname-v1"
  replication_factor = 3
  partitions         = 3

  config   = merge(local.default_topic_config, {})
  provider = kafka.kafka-dev
}
