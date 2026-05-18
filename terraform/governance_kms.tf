data "aws_caller_identity" "current" {}

resource "aws_kms_key" "phi" {
  description             = "Customer managed KMS key for Acme Health PHI data stores and evidence"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name       = "${local.name_prefix}-phi-cmk"
    Control    = "HIPAA-164.312-a-2-iv"
    GapClosure = "GAP-01-GAP-02"
  }
}

resource "aws_kms_alias" "phi" {
  name          = "alias/${local.name_prefix}-phi-${local.suffix}"
  target_key_id = aws_kms_key.phi.key_id
}

