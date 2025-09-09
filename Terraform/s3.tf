// 1. Create the random id for the bucket name.
resource "random_id" "bucket_name" {
  byte_length = 4
}

// 2. Create the S3 bucket for the static website.

resource "aws_s3_bucket" "this" {
  bucket = "keepers-app-static-website-${random_id.bucket_name.hex}"

  tags = {
    Name = "Keepers-App-Static-Website"
  }
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
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.this]

}

// 5. Configure the S3 bucket for static website hosting.

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]
  bucket     = aws_s3_bucket.this.id
  acl        = "private" // Set to private to avoid ACL issues
  // Note: S3 bucket ACLs are not recommended for public access; use bucket policies
}

// 6. Upload the index.html and error.html files to the S3 bucket.

resource "aws_s3_object" "website_files" {
  for_each = fileset("../my-react-app/dist", "**/*") # Adjusted to point to the React app's dist folder

  bucket = aws_s3_bucket.this.id
  key    = each.value
  source = "../my-react-app/dist/${each.value}" # Adjusted to point to the React app's dist folder
  etag   = filemd5("../my-react-app/dist/${each.value}")

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "svg"  = "image/svg+xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream") // Default to binary if not found

}

