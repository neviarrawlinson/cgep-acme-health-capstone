# Layer 1 Governance Baseline Evidence

## Result

The Patient Intake API remained functional after applying the governance baseline and KMS permission fix.

## Smoke Test

Expected result:

status = received

The final smoke test returned a successful submission response and confirmed the API accepted a post-governance patient intake submission.

## Controls Implemented

- Customer-managed KMS key for PHI-related data stores
- S3 uploads bucket SSE-KMS encryption
- S3 uploads bucket versioning
- S3 uploads bucket TLS-only policy
- S3 uploads bucket public access block
- DynamoDB customer-managed KMS encryption
- DynamoDB point-in-time recovery
- Lambda VPC configuration using private subnets
- Lambda least-privilege IAM policy
- Lambda KMS permissions for encrypted DynamoDB writes
- Lambda X-Ray tracing
- CloudTrail multi-region management event logging
- CloudTrail log file validation
- Evidence vault with versioning, SSE-KMS, TLS-only policy, and Object Lock governance retention

## Exception

Reserved concurrency was intentionally not enforced because the sandbox account returned an AWS service quota error. The error stated that reserving concurrency would reduce unreserved account concurrency below the AWS minimum. This will be documented as a capstone trade-off.
