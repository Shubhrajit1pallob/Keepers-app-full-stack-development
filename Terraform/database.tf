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
    username = "dbadmin"
    password = "12-34_ab?"
  }
}