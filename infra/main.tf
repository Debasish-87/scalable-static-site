terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ✅ Create S3 bucket
resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  tags = {
    Project = "ScalableStaticSite"
  }
}

# ✅ Allow public access by disabling blocking rules
resource "aws_s3_bucket_public_access_block" "static_site" {
  bucket                  = aws_s3_bucket.static_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ✅ Enable static website hosting
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

# ✅ Public read policy for static site objects
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static_site.id

  depends_on = [aws_s3_bucket_public_access_block.static_site]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

# ✅ IAM user for GitHub Actions to deploy site
resource "aws_iam_user" "s3_deployer" {
  name = "s3-deployer"
}

resource "aws_iam_access_key" "deployer_key" {
  user = aws_iam_user.s3_deployer.name
}

resource "aws_iam_user_policy" "s3_deploy_policy" {
  name = "S3DeployPolicy"
  user = aws_iam_user.s3_deployer.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.static_site.arn,
          "${aws_s3_bucket.static_site.arn}/*"
        ]
      }
    ]
  })
}

# ✅ Cloudflare DNS for root domain → S3 static site endpoint
resource "cloudflare_record" "root_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  type    = "CNAME"
  content = aws_s3_bucket_website_configuration.static_site.website_endpoint
  ttl     = 1
  proxied = true
}

# ✅ Cloudflare DNS for www → root
resource "cloudflare_record" "www_record" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  content = var.domain_name
  proxied = true
}
