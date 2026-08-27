name              = "plane-test"
domain            = "plane.example.com"
admin_email       = "ops@example.com"
ssh_public_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKeyForValidationOnly test@example.com"
ssh_allowed_cidrs = ["203.0.113.10/32"]

location       = "nbg1"
server_type    = "cax11"
swap_size_gb   = 2
image          = "ubuntu-24.04"
plane_version  = "v1.4.2"
enable_backups = true
enable_ipv6    = true
protect_server = true
