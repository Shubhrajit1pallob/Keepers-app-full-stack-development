##############################
# Subnet Validation
# We are not making the resource here, we are just taking the subnet that already exists.
##############################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "input" {
  for_each = toset(var.subnet_ids)
  id       = each.value

  lifecycle {
    postcondition {
      condition     = self.vpc_id != data.aws_vpc.default.id
      error_message = <<-EOT
      The subnet must not belong to the default VPC. Please select a subnet from a custom VPC.

      Name: ${self.tags["Name"]}
      ID: ${self.id}
      EOT
    }

    postcondition {
      condition     = can(lower(self.tags.Access) == "private")
      error_message = <<-EOT
      The subnet must be private. Please tag the below subnets with "Access" set to "private".

      Name: ${self.tags["Name"]}
      ID: ${self.id}
      EOT
    }
  }
}

##############################
# Security Group Validation
##############################

data "aws_vpc_security_group_rules" "input" {
  filter {
    name   = "group-id"
    values = var.security_group_ids
  }
}

data "aws_vpc_security_group_rule" "input" {
  for_each               = toset(data.aws_vpc_security_group_rules.input.ids)
  security_group_rule_id = each.value

  lifecycle {
    postcondition {
      condition = (
        self.is_egress ? true :
        self.cidr_ipv4 == null && self.cidr_ipv6 == null && self.referenced_security_group_id != null
      )
      error_message = <<-EOT
      The security group contains an invalid inbound rule.
      ID = ${self.id}
      Please ensure that all inbound rules either reference another security group or specify a CIDR block.
      EOT
    }
  }
}