output "vpc_id" {
  value = module.network.vpc_id
}

output "subnets" {
  value = module.network.public_subnets
}

output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}
