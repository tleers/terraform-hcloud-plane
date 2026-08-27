mock_provider "hcloud" {
  mock_resource "hcloud_firewall" {
    defaults = {
      id = "30001"
    }
  }

  mock_resource "hcloud_ssh_key" {
    defaults = {
      id = "40001"
    }
  }

  mock_resource "hcloud_primary_ip" {
    defaults = {
      id         = "10001"
      ip_address = "203.0.113.42"
    }
  }

  mock_resource "hcloud_server" {
    defaults = {
      id           = "20001"
      ipv4_address = "203.0.113.42"
      ipv6_address = "2001:db8::42"
    }
  }
}

variables {
  domain            = "plane.example.com"
  admin_email       = "ops@example.com"
  ssh_public_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKeyForValidationOnly test@example.com"
  ssh_allowed_cidrs = ["203.0.113.10/32"]
  server_type       = "cax11"
  swap_size_gb      = 2
  plane_version     = "v1.4.2"
  protect_server    = true
}

run "secure_defaults" {
  command = plan

  assert {
    condition     = hcloud_server.plane.backups
    error_message = "Server backups must be enabled by default."
  }

  assert {
    condition     = hcloud_server.plane.delete_protection && hcloud_server.plane.rebuild_protection
    error_message = "Destructive operations must be protected by default."
  }

  assert {
    condition     = hcloud_server.plane.server_type == "cax11"
    error_message = "The default server must provide the documented low-cost 4 GB baseline."
  }

  assert {
    condition     = strcontains(hcloud_server.plane.user_data, "plane.example.com")
    error_message = "Cloud-init must contain the configured Plane hostname."
  }

  assert {
    condition     = strcontains(hcloud_server.plane.user_data, "openssl rand -hex")
    error_message = "Application secrets must be generated on the server."
  }
}

run "swap_safety_valve" {
  command = plan

  variables {
    swap_size_gb = 4
  }

  assert {
    condition     = strcontains(hcloud_server.plane.user_data, "swap_size_gb=4")
    error_message = "Configured swap size must be rendered into cloud-init."
  }

  assert {
    condition     = strcontains(hcloud_server.plane.user_data, "chmod 0600 /swapfile")
    error_message = "The swap file must be root-only."
  }
}

run "cost_profile_defaults" {
  command = plan

  assert {
    condition     = strcontains(hcloud_server.plane.user_data, "swap_size_gb=2")
    error_message = "The low-cost CAX11 profile must render its 2 GiB swap safety valve by default."
  }

  assert {
    condition     = strcontains(hcloud_server.plane.user_data, "release=\"v1.4.2\"")
    error_message = "Cloud-init must use the supported pinned Plane release by default."
  }
}

run "network_surface" {
  command = plan

  assert {
    condition = length([
      for rule in hcloud_firewall.plane.rule : rule
      if rule.protocol == "tcp" && contains(["80", "443"], rule.port)
    ]) == 2
    error_message = "Only the expected public web ports must be present."
  }

  assert {
    condition = alltrue([
      for rule in hcloud_firewall.plane.rule : toset(rule.source_ips) == toset(["203.0.113.10/32"])
      if rule.protocol == "tcp" && rule.port == "22"
    ])
    error_message = "SSH must be restricted to ssh_allowed_cidrs."
  }
}
