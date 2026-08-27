variable "ssh_public_key" {
  description = "SSH public key used to administer the example server."
  type        = string
  sensitive   = true
}
