output "ipv4_address" {
  description = "Create your domain's A record with this address."
  value       = hcloud_primary_ip.plane.ip_address
}

output "server_id" {
  description = "Hetzner Cloud server ID."
  value       = hcloud_server.plane.id
}

output "firewall_id" {
  description = "Hetzner Cloud Firewall ID."
  value       = hcloud_firewall.plane.id
}

output "ipv6_address" {
  description = "Optional IPv6 address for an AAAA record."
  value       = hcloud_server.plane.ipv6_address
}

output "plane_url" {
  description = "Public HTTPS URL for the Plane instance."
  value       = "https://${var.domain}"
}

output "ssh_command" {
  description = "Command for connecting to the server as root."
  value       = "ssh root@${hcloud_primary_ip.plane.ip_address}"
}

output "bootstrap_log_command" {
  description = "Command for waiting on cloud-init and showing the sanitized bootstrap tail."
  value       = "ssh root@${hcloud_primary_ip.plane.ip_address} 'cloud-init status --wait --long && tail -n 100 /var/log/plane-bootstrap.log'"
}
