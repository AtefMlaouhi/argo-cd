variable "kafka_urls" {
  type = object({
    default = object({
      dev     = string
      rci     = string
      preprod = string
      rcc     = string
      prod    = string
    })
    sasl = object({
      dev     = string
      rci     = string
      preprod = string
      rcc     = string
      prod    = string
    })
  })
  default = {
    default = {
      dev     = "kafka-k8s.dev.harvest.fr:4430"
      rci     = "kafka-k8s.rci.harvest.fr:4430"
      preprod = "kafka-k8s.preprod.harvest.fr:4430"
      rcc     = "kafka-recette.harvest.fr:4430"
      prod    = "kafka.harvest.fr:4430"
    }
    sasl = {
      dev     = "kafka-k8s.dev.harvest.fr:4430"
      rci     = "kafka-k8s.rci.harvest.fr:4430"
      preprod = "kafka-k8s.preprod.harvest.fr:4430"
      rcc     = "kafka-recette.harvest.fr:4430"
      prod    = "kafka.harvest.fr:4430"
    }
  }
}
