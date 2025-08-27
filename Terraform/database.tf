module "database" {
  source       = "./modules/rds"
  project_name = "keepers-app"
  security_group_ids = [
    aws_security_group.ec2.id,
    aws_security_group.db.id
  ]
  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  credentials = {
    username = var.db_username
    password = var.db_password
  }
}

# I am not going to apply now I will do that in the github actions workflow file that will be a good place to start the next part of the project. Now we have to deploy through the CI/CD pipeline and bring the project together.