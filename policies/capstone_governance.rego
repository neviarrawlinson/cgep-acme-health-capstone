package capstone.governance

resources[type] = rs {
  rs := [r | r := input.planned_values.root_module.resources[_]; r.type == type]
}

has_resource(type, name) {
  some r
  r := input.planned_values.root_module.resources[_]
  r.type == type
  r.name == name
}

resource(type, name) = r {
  some item
  item := input.planned_values.root_module.resources[_]
  item.type == type
  item.name == name
  r := item
}

deny[msg] {
  not has_resource("aws_kms_key", "phi")
  msg := "[GAP-01/GAP-02] Missing customer-managed KMS key for PHI data stores."
}

deny[msg] {
  r := resource("aws_s3_bucket_server_side_encryption_configuration", "uploads")
  rule := r.values.rule[_]
  enc := rule.apply_server_side_encryption_by_default[_]
  enc.sse_algorithm != "aws:kms"
  msg := "[GAP-01] Uploads bucket must use SSE-KMS encryption."
}

deny[msg] {
  not has_resource("aws_s3_bucket_server_side_encryption_configuration", "uploads")
  msg := "[GAP-01] Uploads bucket encryption configuration is missing."
}

deny[msg] {
  r := resource("aws_s3_bucket_versioning", "uploads")
  r.values.versioning_configuration[_].status != "Enabled"
  msg := "[GAP-04] Uploads bucket versioning must be enabled."
}

deny[msg] {
  not has_resource("aws_s3_bucket_versioning", "uploads")
  msg := "[GAP-04] Uploads bucket versioning configuration is missing."
}

deny[msg] {
  not has_resource("aws_s3_bucket_policy", "uploads_tls_only")
  msg := "[GAP-03] Uploads bucket TLS-only deny policy is missing."
}

deny[msg] {
  r := resource("aws_dynamodb_table", "intake")
  not r.values.server_side_encryption
  msg := "[GAP-02] DynamoDB table must use customer-managed encryption."
}

deny[msg] {
  r := resource("aws_dynamodb_table", "intake")
  not r.values.point_in_time_recovery
  msg := "[HIPAA Contingency] DynamoDB point-in-time recovery must be enabled."
}

deny[msg] {
  r := resource("aws_lambda_function", "intake")
  count(r.values.vpc_config) == 0
  msg := "[GAP-05] Lambda function must be configured inside the VPC."
}

deny[msg] {
  r := resource("aws_lambda_function", "intake")
  r.values.tracing_config[_].mode != "Active"
  msg := "[GAP-06] Lambda X-Ray tracing must be active."
}

deny[msg] {
  not has_resource("aws_cloudtrail", "management")
  msg := "[Audit Controls] CloudTrail management trail is missing."
}

deny[msg] {
  r := resource("aws_cloudtrail", "management")
  r.values.enable_log_file_validation != true
  msg := "[Audit Controls] CloudTrail log file validation must be enabled."
}

deny[msg] {
  r := resource("aws_cloudtrail", "management")
  r.values.is_multi_region_trail != true
  msg := "[Audit Controls] CloudTrail must be multi-region."
}

deny[msg] {
  not has_resource("aws_s3_bucket_object_lock_configuration", "evidence_vault")
  msg := "[Evidence Integrity] Evidence vault Object Lock configuration is missing."
}

deny[msg] {
  r := resource("aws_s3_bucket_object_lock_configuration", "evidence_vault")
  r.values.rule[_].default_retention[_].mode != "GOVERNANCE"
  msg := "[Evidence Integrity] Evidence vault must use Object Lock GOVERNANCE retention."
}

deny[msg] {
  not has_resource("aws_s3_bucket_server_side_encryption_configuration", "evidence_vault")
  msg := "[Evidence Integrity] Evidence vault encryption configuration is missing."
}
