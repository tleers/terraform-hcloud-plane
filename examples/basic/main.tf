terraform {
  required_version = ">= 1.8.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.64"
    }
  }
}

module "plane" {
  source = "../.."

  domain            = "plane.example.com"
  admin_email       = "ops@example.com"
  ssh_public_key    = var.ssh_public_key
  ssh_allowed_cidrs = ["203.0.113.10/32"]
}

output "plane_url" {
  value = module.plane.plane_url
}
