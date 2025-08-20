output "website_url" {
  value = "http://${aws_s3_bucket.this.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}

output "api_endpoint" {
  value       = "http://${aws_instance.this.public_ip}:8080"
  description = "The API endpoint for the application"
}