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

  name              = "company-plane"
  domain            = "plane.example.com"
  admin_email       = "ops@example.com"
  ssh_public_key    = var.ssh_public_key
  ssh_allowed_cidrs = ["203.0.113.10/32", "2001:db8::10/128"]

  location       = "nbg1"
  server_type    = "cax11"
  swap_size_gb   = 2
  image          = "ubuntu-24.04"
  plane_version  = "v1.4.2"
  enable_backups = true
  enable_ipv6    = true
  protect_server = true

  labels = {
    environment = "production"
    owner       = "platform"
  }
}

output "plane_url" {
  value = module.plane.plane_url
}

output "ipv4_address" {
  value = module.plane.ipv4_address
}

output "bootstrap_log_command" {
  value = module.plane.bootstrap_log_command
}
