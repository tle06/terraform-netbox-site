terraform {
  required_version = "~> 1.0"

  required_providers {
    netbox = {
      source  = "tle06/netbox"
      version = "0.1.0-alpha.7"
    }
  }
}