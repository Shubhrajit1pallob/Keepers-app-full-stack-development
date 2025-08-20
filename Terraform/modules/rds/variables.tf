##############################
# General Information
##############################

variable "project_name" {
  description = "The name of the RDS instance"
  type        = string
}

##############################
# DB Configuration
##############################

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance class for the RDS instance. Only db.t3.micro is allowed."

  validation {
    condition     = contains(["db.t3.micro"], var.instance_class)
    error_message = "Only db.t3.micro is allowed for instance_class."
  }
}

variable "storage_size" {
  type        = number
  default     = 8
  description = "Storage size in GB for the RDS instance. Must be between 5 and 10 GB."

  validation {
    condition     = var.storage_size >= 5 && var.storage_size <= 10
    error_message = "The DB storage size must be greater than 5 GB and less than or equal to 10 GB."
  }
}

variable "engine" {
  type        = string
  default     = "postgress-latest"
  description = "The database engine for the RDS instance. Must be either 'postgress-latest' or 'postgress14'."

  validation {
    condition     = contains(["postgress-latest", "postgress-14"], var.engine)
    error_message = "DB engine must be either 'postgress-latest' or 'postgress-14'."
  }
}

##############################
# DB Credentials
##############################
variable "credentials" {
  type = object({
    username = string
    password = string
  })

  description = "The credentials for the RDS instance. The username must be alphanumeric and the password must meet specific criteria."

  sensitive = true

  validation {
    condition = (
      length(regexall("[a-zA-Z0-9]+", var.credentials.password)) > 0
      && length(regexall("[0-9]+", var.credentials.password)) > 0
      && length(regexall("^[a-zA-Z0-9+_?-]{6,}$", var.credentials.password)) > 0
    )
    error_message = <<-EOT
    The password must:
    1. Be at least 6 characters long
    2. Contain at least one letter
    3. Contain at least one number
    4. Contain only alphanumeric characters, plus '_', '?', and '-'
    EOT
  }
}

##############################
# DB Network Configuration
##############################

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs where the RDS instance will be deployed."
}

variable "security_group_ids" {
  type        = list(string)
  description = "The list of security group IDs to associate with the RDS instance."
}