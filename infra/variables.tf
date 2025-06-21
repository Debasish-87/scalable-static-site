variable "bucket_name" {
  type        = string
  description = "Unique S3 bucket name for static site"
}

variable "domain_name" {
  type        = string
  description = "Domain name for website"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token with DNS edit permissions"
}
