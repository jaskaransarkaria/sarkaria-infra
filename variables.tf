variable "CIVO_API_KEY" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "MY_IP_ADDRESS" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "CLUSTER_NAME" {
  type     = string
  nullable = false
}
