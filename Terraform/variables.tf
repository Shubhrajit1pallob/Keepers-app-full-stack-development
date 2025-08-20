variable "key_name" {
  description = "This is the name of the key pair to use for SSH access to the instance."
  type        = string
  default     = "developer_key"
}

variable "public_key" {
  description = "This is the public key for SSH access to the instance."
  type        = string
}

variable "db_username" {
  description = "The username for the db instance."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the db instance."
  type        = string
  sensitive   = true
}