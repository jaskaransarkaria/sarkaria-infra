terraform {
  required_providers {
    civo = {
      source = "civo/civo"
      version = "1.0.31"
    }
  }
}

provider "civo" {
  # Configuration options
  token = var.CIVO_API_KEY
  region = "LON1"
}
