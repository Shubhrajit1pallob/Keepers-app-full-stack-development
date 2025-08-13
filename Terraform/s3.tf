// 1. Create the random id for the bucket name.

resource "random_id" "bucket_name" {
  byte_length = 4
}

// 2. Create the S3 bucket for the static website.

resource "aws_s3_bucket" "this" {
  bucket = "Keepers-App-Static-Website-${random_id.bucket_name.hex}"
}

// 3. Configure the public access block for the S3 bucket.

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// 4. Set the bucket policy to allow public read access.

resource "aws_s3_bucket_policy" "static_website_public_read" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website_bucket.arn}/*"
      }
    ]
  })
  
}

// 5. Configure the S3 bucket for static website hosting.
// 6. Upload the index.html and error.html files to the S3 bucket.
