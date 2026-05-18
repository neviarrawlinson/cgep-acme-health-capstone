package capstone.governance

has_resource(type, name) if {
  some i
  input.planned_values.root_module.resources[i].type == type
  input.planned_values.root_module.resources[i].name == name
}

resource_by_name(type, name) := resource if {
  some i
  resource := input.planned_values.root_module.resources[i]
  resource.type == type
  resource.name == name
}

deny contains msg if {
  not has_resource("aws_kms_key", "phi")
  msg := "[GAP-01/GAP-02] Missing customer-managed KMS key for PHI data stores."
}

deny contains msg if {
  not has_resource("aws_s3_bucket_server_side_encryption_configuration", "uploads")
  msg := "[GAP-01] Uploads bucket encryption configuration is missing."
}

deny contains msg if {
  resource := resource_by_name("aws_s3_bucket_server_side_encryption_configuration", "uploads")
  rule := resource.values.rule[_]
  enc := rule.apply_server_side_encryption_by_default[_]
  enc.sse_algorithm != "aws:kms"
  msg := "[GAP-01] Uploads bucket must use SSE-KMS encryption."
}

deny contains msg if {
  not has_resource("aws_s3_bucket_versioning", "uploads")
  msg := "[GAP-04] Uploads bucket versioning configuration is missing."
}

deny contains msg if {
  resource := resource_by_name("aws_s3_bucket_versioning", "uploads")
  resource.values.versioning_configuration[_].status != "Enabled"
  msg := "[GAP-04] Uploads bucket versioning must be enabled."
}

deny contains msg if {
  not has_resource("aws_s3_bucket_policy", "uploads_tls_only")
  msg := "[GAP-03] Uploads bucket TLS-only deny policy is missing."
}

deny contains msg if {
  resource := resource_by_name("aws_dynamodb_table", "intake")
  count(resource.values.server_side_encryption) == 0
  msg := "[GAP-02] DynamoDB table must use customer-managed encryption."
}

deny contains msg if {
  resource := resource_by_name("aws_dynamodb_table", "intake")
  count(resource.values.point_in_time_recovery) == 0
  msg := "[HIPAA Contingency] DynamoDB point-in-time recovery must be enabled."
}

deny contains msg if {
  resource := resource_by_name("aws_lambda_function", "intake")
  count(resource.values.vpc_config) == 0
  msg := "[GAP-05] Lambda function must be configured inside the VPC."
}

deny contains msg if {
  resource := resource_by_name("aws_lambda_function", "intake")
  resource.values.tracing_config[_].mode != "Active"
  msg := "[GAP-06] Lambda X-Ray tracing must be active."
}

deny contains msg if {
  not has_resource("aws_cloudtrail", "management")
  msg := "[Audit Controls] CloudTrail management trail is missing."
}

deny contains msg if {
  resource := resource_by_name("aws_cloudtrail", "management")
  resource.values.enable_log_file_validation != true
  msg := "[Audit Controls] CloudTrail log file validation must be enabled."
}

deny contains msg if {
  resource := resource_by_name("aws_cloudtrail", "management")
  resource.values.is_multi_region_trail != true
  msg := "[Audit Controls] CloudTrail must be multi-region."
}

deny contains msg if {
  not has_resource("aws_s3_bucket_object_lock_configuration", "evidence_vault")
  msg := "[Evidence Integrity] Evidence vault Object Lock configuration is missing."
}

deny contains msg if {
  resource := resource_by_name("aws_s3_bucket_object_lock_configuration", "evidence_vault")
  resource.values.rule[_].default_retention[_].mode != "GOVERNANCE"
  msg := "[Evidence Integrity] Evidence vault must use Object Lock GOVERNANCE retention."
}

deny contains msg if {
  not has_resource("aws_s3_bucket_server_side_encryption_configuration", "evidence_vault")
  msg := "[Evidence Integrity] Evidence vault encryption configuration is missing."
}
