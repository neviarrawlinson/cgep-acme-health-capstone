# CGE-P Capstone Write-Up

## Executive Summary

This capstone implements a governed Acme Health Patient Intake API for a fictional telehealth company. The system began as a starter workload with intentional security and compliance gaps. The capstone remediates those gaps using Terraform, policy-as-code, GitHub Actions, signed evidence, an S3 evidence vault, and OSCAL documentation.

The primary goal was to show that GRC requirements can be translated into enforceable engineering controls, validated automatically, and supported by durable evidence.

## Primary Framework

Primary framework: HIPAA Security Rule

I selected the HIPAA Security Rule because Acme Health is modeled as a telehealth company and the Patient Intake API may handle protected health information. The most important compliance objective is protecting patient data through access control, encryption, audit logging, integrity safeguards, and transmission security.

SOC 2 and CMMC were considered as secondary frameworks, but HIPAA is the most directly aligned to the workload, data type, and risk profile.

## Architecture Overview

The governed Patient Intake API includes:

- API Gateway HTTP API for the /intake endpoint
- AWS Lambda intake handler
- DynamoDB submissions table
- S3 uploads bucket
- Customer-managed AWS KMS key
- Private Lambda networking with VPC endpoints
- CloudTrail management event logging
- S3 evidence vault with Object Lock governance retention
- Rego policy checks evaluated with Conftest
- GitHub Actions GRC workflow
- Signed evidence bundle with SHA-256 hash, Cosign signature, receipt, and S3 vault listing
- OSCAL component definition linking implemented safeguards to evidence

## Design Decisions

### AWS Region

The workload was deployed in us-east-1 because the starter app deployed successfully there and the region was used consistently for the governance baseline, evidence vault, CloudTrail, policy evidence, and signed evidence package.

### Object Lock Mode

The evidence vault uses S3 Object Lock in GOVERNANCE mode. This gives the evidence bundle retention protection while still allowing authorized cleanup in a sandbox learning environment. In a production audit environment, COMPLIANCE mode may be more appropriate depending on legal, regulatory, and retention requirements.

### Pipeline Model

The pipeline model is pull-request and branch based. GitHub Actions validates Terraform formatting, Terraform initialization, Terraform validation, policy checks, and workflow evidence packaging. Local evidence signing was used for the final capstone evidence bundle because the S3 vault and Cosign tooling had already been validated through the lab sequence.

### Account Model

The capstone uses a single AWS sandbox account. A separate evidence account would provide stronger separation of duties, but a single account is acceptable for this learning environment. The capstone still applies evidence protection through KMS encryption, versioning, Object Lock, SHA-256 hashing, Cosign signing, and receipt metadata.

## Gap Closure Summary

| Gap | Remediation | Evidence |
|---|---|---|
| GAP-01 S3 uploads bucket encryption | Added SSE-KMS using a customer-managed KMS key | evidence/capstone/uploads-bucket-encryption.json |
| GAP-02 DynamoDB encryption | Added customer-managed KMS encryption and point-in-time recovery | evidence/capstone/dynamodb-table.json, evidence/capstone/dynamodb-pitr.json |
| GAP-03 S3 non-TLS access | Added bucket policy denying insecure transport | evidence/capstone/uploads-bucket-policy.json |
| GAP-04 S3 versioning | Enabled uploads bucket versioning | evidence/capstone/uploads-bucket-versioning.json |
| GAP-05 Lambda networking | Placed Lambda in private subnets with VPC endpoints | evidence/capstone/lambda-configuration.json |
| GAP-06 Observability | Enabled Lambda X-Ray tracing | evidence/capstone/lambda-configuration.json |
| GAP-07 IAM least privilege | Replaced broad access with limited DynamoDB, S3, KMS, and X-Ray actions | evidence/capstone/lambda-iam-policy.json |
| Evidence integrity | Added S3 evidence vault with encryption, versioning, Object Lock, signing, and receipt metadata | evidence/capstone-signed/ |
| Audit controls | Added multi-region CloudTrail with log file validation | evidence/capstone/cloudtrail-status.json |

## Policy-as-Code

The capstone includes a Rego policy suite under policies/. The policy suite validates the governance baseline using Terraform plan JSON and Conftest.

The policy gate checks for:

- Customer-managed KMS key
- S3 uploads bucket SSE-KMS encryption
- S3 uploads bucket versioning
- S3 uploads bucket TLS-only policy
- DynamoDB customer-managed encryption
- DynamoDB point-in-time recovery
- Lambda VPC configuration
- Lambda X-Ray tracing
- CloudTrail multi-region configuration
- CloudTrail log file validation
- Evidence vault Object Lock
- Evidence vault encryption

Policy evidence is captured in:

```text
evidence/capstone/capstone-plan.json
evidence/capstone/capstone-conftest-results.json
```

## Evidence Pipeline

The capstone evidence workflow creates repeatable evidence from Terraform, AWS service checks, Conftest results, GitHub Actions workflow context, and signed bundle metadata.

The signed evidence package includes:

- Capstone evidence bundle
- SHA-256 hash file
- Cosign signature bundle
- Receipt JSON
- Vault listing
- SHA-256 verification output
- Cosign verification output
- Object Lock retention evidence

The signed evidence is stored in:

```text
s3://acme-health-intake-evidence-c197281c/capstone/runs/26009609442/
```

The signed evidence metadata is stored locally in:

```text
evidence/capstone-signed/
```

## OSCAL

The capstone includes an OSCAL component definition for the Acme Health Patient Intake API.

```text
oscal/component-definitions/acme-health-intake/component-definition.json
```

The OSCAL artifact maps selected HIPAA Security Rule safeguards to implemented technical controls and links those controls to evidence artifacts. It represents the governed API as a software component with implementation statements for encryption, audit controls, integrity, and transmission security.

## Validation Results

The capstone validation results include:

- Starter deploy gate passed
- Post-governance smoke test passed
- Terraform reached a clean no-change state
- Rego policy gate passed locally
- GitHub Actions capstone GRC workflow passed
- Signed evidence bundle was created
- SHA-256 verification passed
- Cosign verification passed
- Evidence vault Object Lock retention was confirmed
- OSCAL JSON parsed successfully

## Trade-Offs

Reserved Lambda concurrency was not enforced because the sandbox account returned a service quota error. The error indicated that reserving concurrency would reduce unreserved account concurrency below the AWS minimum. I documented this as an implementation trade-off rather than forcing a setting that the sandbox account could not support.

The evidence vault is in the same AWS sandbox account as the workload. A stronger production architecture would use a separate audit or security account for evidence storage and retention.

The final signed evidence process was completed locally using Cosign keyless signing and uploaded to S3. In a production version, I would move signing and upload fully into the GitHub Actions workflow with OIDC-based AWS access.

## What I Would Do With Another Sprint

With another sprint, I would add:

- API Gateway access logging
- API Gateway throttling
- WAF protection for the intake endpoint
- Automated signed evidence upload directly from GitHub Actions
- More granular Rego checks for IAM wildcard detection
- Negative policy test fixtures showing intentional failures
- A fuller OSCAL system security plan
- Cross-framework mapping to SOC 2 and NIST 800-53
- Separate evidence account architecture

## What I Did Not Get To

I did not fully implement API Gateway access logging, throttling, or WAF. These were treated as stretch controls because the highest priority was closing the PHI data protection, audit logging, evidence integrity, and policy enforcement gaps.

I also did not create a full OSCAL system security plan. Instead, I created a focused OSCAL component definition that maps implemented safeguards to evidence, which is appropriate for the capstone timeline.

## Conclusion

This capstone demonstrates a practical GRC Engineering workflow. The final system shows how governance requirements can be translated into Terraform controls, enforced through Rego policies, validated in CI, documented with OSCAL, and supported by signed, retention-protected evidence.
