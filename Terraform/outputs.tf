output "website_url" {
  value = "http://${aws_s3_bucket.this.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}

output "api_endpoint" {
  value       = "http://${aws_instance.this.public_ip}:8080"
  description = "The API endpoint for the application"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "instance_elastic_ip" {
  value       = aws_eip.this.public_ip
  description = "The Elastic IP address of the instance"
}

output "rds_instance_endpoint" {
  value       = module.database.rds_instance_endpoint
  description = "The RDS instance endpoint"
}

output "rds_instance_port" {
  value       = module.database.rds_instance_port
  description = "The RDS instance port"
}

output "rds_instance_name" {
  value       = module.database.rds_instance_name
  description = "The RDS instance name"
}