output "s3_bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "s3_bucket_url" {
  value = aws_s3_bucket_website_configuration.static_site.website_endpoint
}

output "aws_access_key_id" {
  value = aws_iam_access_key.deployer_key.id
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.deployer_key.secret
  sensitive = true
}
