output "evidence_vault_bucket" {
  value       = aws_s3_bucket.evidence_vault.id
  description = "S3 bucket used as the signed evidence vault."
}

output "cloudtrail_bucket" {
  value       = aws_s3_bucket.cloudtrail_logs.id
  description = "S3 bucket used for CloudTrail management event logs."
}

output "cloudtrail_name" {
  value       = aws_cloudtrail.management.name
  description = "Multi-region CloudTrail name."
}

output "phi_kms_key_arn" {
  value       = aws_kms_key.phi.arn
  description = "Customer managed KMS key used for PHI-related data stores."
}
