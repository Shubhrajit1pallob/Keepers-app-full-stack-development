variable "key_name" {
  description = "This is the name of the key pair to use for SSH access to the instance."
  type        = string
}

variable "public_key" {
  description = "This is the public key for SSH access to the instance."
  type        = string
}