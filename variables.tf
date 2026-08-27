variable "name" {
  description = "Name used for the Plane server and firewall."
  type        = string
  default     = "plane"
}

variable "domain" {
  description = "Public hostname for Plane, for example plane.example.com."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)+$", var.domain))
    error_message = "domain must be a lowercase fully qualified domain name."
  }
}

variable "admin_email" {
  description = "Email used for Let's Encrypt certificate notices."
  type        = string

  validation {
    condition     = can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", var.admin_email))
    error_message = "admin_email must be a valid email address."
  }
}

variable "ssh_public_key" {
  description = "SSH public key to create and install for root access. Set null when supplying existing ssh_key_ids."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "ssh_key_ids" {
  description = "Existing Hetzner Cloud SSH key IDs to install in addition to ssh_public_key."
  type        = list(string)
  default     = []
}

variable "ssh_allowed_cidrs" {
  description = "IPv4 or IPv6 CIDRs allowed to SSH to the server. Keep this narrow."
  type        = list(string)

  validation {
    condition     = length(var.ssh_allowed_cidrs) > 0 && alltrue([for cidr in var.ssh_allowed_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR for SSH access."
  }
}

variable "location" {
  description = "Hetzner Cloud location."
  type        = string
  default     = "nbg1"
}

variable "image" {
  description = "Hetzner image used for the server. The bootstrap is tested with Ubuntu 24.04."
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "Hetzner server type. The default CAX11 provides 2 ARM vCPU, 4 GB RAM, and 40 GB disk; choose CAX21 for the 8 GB profile."
  type        = string
  default     = "cax11"
}

variable "swap_size_gb" {
  description = "Size of the persistent host swap file in GiB. The default is a 2 GiB OOM safety valve for the CAX11 profile, not a substitute for adequate RAM."
  type        = number
  default     = 2

  validation {
    condition     = var.swap_size_gb >= 0 && var.swap_size_gb <= 16 && floor(var.swap_size_gb) == var.swap_size_gb
    error_message = "swap_size_gb must be a whole number between 0 and 16."
  }
}

variable "plane_version" {
  description = "Pinned Plane Community Edition release. Upgrade deliberately after taking a backup."
  type        = string
  default     = "v1.4.2"

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.plane_version))
    error_message = "plane_version must be a release tag such as v1.4.2."
  }
}

variable "enable_backups" {
  description = "Enable Hetzner's seven rotating server backup slots."
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Attach a free public IPv6 address to the server."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Additional labels merged onto the server's module-managed labels."
  type        = map(string)
  default     = {}
}

variable "protect_server" {
  description = "Enable Hetzner delete and rebuild protection. Set false and apply before intentionally destroying."
  type        = bool
  default     = true
}
