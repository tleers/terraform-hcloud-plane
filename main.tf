resource "hcloud_ssh_key" "plane" {
  count = var.ssh_public_key == null ? 0 : 1

  name       = "${var.name}-admin"
  public_key = trimspace(coalesce(var.ssh_public_key, ""))
}

resource "hcloud_primary_ip" "plane" {
  name        = "${var.name}-ipv4"
  type        = "ipv4"
  location    = var.location
  auto_delete = false
}

resource "hcloud_firewall" "plane" {
  name = "${var.name}-firewall"

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = var.ssh_allowed_cidrs
    description = "Restricted SSH"
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "HTTP and ACME"
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "HTTPS"
  }

  rule {
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Path MTU and diagnostics"
  }
}

resource "hcloud_server" "plane" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  backups     = var.enable_backups
  ssh_keys    = concat(var.ssh_key_ids, hcloud_ssh_key.plane[*].id)

  firewall_ids       = [hcloud_firewall.plane.id]
  delete_protection  = var.protect_server
  rebuild_protection = var.protect_server

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.plane.id
    ipv6_enabled = var.enable_ipv6
  }

  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    domain        = var.domain
    admin_email   = var.admin_email
    plane_version = var.plane_version
    swap_size_gb  = var.swap_size_gb
  })

  labels = merge(
    {
      app        = "plane"
      managed_by = "opentofu"
    },
    var.labels
  )
}

check "ssh_access" {
  assert {
    condition     = var.ssh_public_key != null || length(var.ssh_key_ids) > 0
    error_message = "Provide ssh_public_key or at least one existing ssh_key_ids entry."
  }
}
