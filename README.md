# CGE-P Capstone: Acme Health Patient Intake API

This repository contains the final CGE-P capstone project for a governed Acme Health Patient Intake API. The project demonstrates how GRC Engineering practices can be applied to a real cloud workload by translating compliance requirements into Terraform controls, policy-as-code checks, CI validation, signed evidence, evidence vaulting, and OSCAL documentation.

## Capstone Scenario

Acme Health is a fictional 50-person telehealth company operating a Patient Intake API. The application accepts patient intake submissions and may handle protected health information. The original starter application included intentional security and compliance gaps. This capstone remediates those gaps and creates an audit-ready evidence trail.

## Primary Framework

Primary framework: HIPAA Security Rule

HIPAA was selected because the system is modeled around a telehealth patient intake workflow. The key risk is the protection of patient data through encryption, access control, audit logging, integrity safeguards, and transmission security.

## What This Capstone Demonstrates

- Infrastructure as Code using Terraform
- Secure AWS baseline implementation
- HIPAA-aligned technical control remediation
- Policy as Code using Rego and Conftest
- GitHub Actions GRC validation workflow
- Evidence capture using Terraform, AWS CLI, and workflow artifacts
- Signed evidence using Cosign keyless signing
- SHA-256 evidence hashing
- S3 evidence vaulting with Object Lock governance retention
- OSCAL component definition linked to evidence
- Final capstone write-up documenting design decisions, trade-offs, and validation results

## Architecture Overview

| Component | Purpose |
|---|---|
| API Gateway HTTP API | Exposes the /intake endpoint |
| AWS Lambda | Processes patient intake submissions |
| DynamoDB | Stores intake submission records |
| S3 uploads bucket | Stores uploaded intake-related objects |
| AWS KMS | Provides customer-managed encryption for PHI-related data stores |
| VPC private subnets | Hosts Lambda network configuration |
| VPC endpoints | Supports private service access to S3 and DynamoDB |
| CloudTrail | Captures management event audit logs |
| S3 evidence vault | Stores signed evidence with retention protection |
| Rego and Conftest | Enforces policy-as-code checks |
| GitHub Actions | Runs capstone GRC validation workflow |
| OSCAL | Documents implemented safeguards and evidence links |

## Repository Structure

- .github/workflows/capstone-grc-gate.yml
- docs/design-decisions.md
- evidence/deploy-gate/
- evidence/capstone/
- evidence/capstone-signed/
- oscal/component-definitions/acme-health-intake/component-definition.json
- policies/capstone_governance.rego
- scripts/capstone-policy-gate.sh
- terraform/
- GAPS.md
- FRAMEWORKS.md
- WRITEUP.md

## Gap Closure Summary

| Gap | Remediation | Evidence |
|---|---|---|
| GAP-01 S3 uploads bucket encryption | Added SSE-KMS using a customer-managed KMS key | evidence/capstone/uploads-bucket-encryption.json |
| GAP-02 DynamoDB encryption | Added customer-managed KMS encryption and point-in-time recovery | evidence/capstone/dynamodb-table.json and evidence/capstone/dynamodb-pitr.json |
| GAP-03 S3 non-TLS access | Added bucket policy denying insecure transport | evidence/capstone/uploads-bucket-policy.json |
| GAP-04 S3 versioning | Enabled uploads bucket versioning | evidence/capstone/uploads-bucket-versioning.json |
| GAP-05 Lambda networking | Placed Lambda in private subnets with VPC endpoints | evidence/capstone/lambda-configuration.json |
| GAP-06 Observability | Enabled Lambda X-Ray tracing | evidence/capstone/lambda-configuration.json |
| GAP-07 IAM least privilege | Replaced broad permissions with limited DynamoDB, S3, KMS, and X-Ray actions | evidence/capstone/lambda-iam-policy.json |
| Audit controls | Added multi-region CloudTrail with log file validation | evidence/capstone/cloudtrail-status.json |
| Evidence integrity | Added S3 evidence vault with encryption, versioning, Object Lock, signing, and receipt metadata | evidence/capstone-signed/ |

## Terraform Governance Baseline

The Terraform governance baseline adds:

- Customer-managed KMS key for PHI-related data stores
- S3 uploads bucket SSE-KMS encryption
- S3 uploads bucket versioning
- S3 uploads bucket public access block
- S3 uploads bucket TLS-only deny policy
- DynamoDB customer-managed encryption
- DynamoDB point-in-time recovery
- Lambda VPC configuration using private subnets
- Lambda least-privilege IAM policy
- Lambda KMS permissions for encrypted DynamoDB writes
- Lambda X-Ray tracing
- S3 and DynamoDB VPC endpoints
- CloudTrail multi-region management event logging
- CloudTrail log file validation
- Evidence vault with versioning, SSE-KMS, TLS-only policy, and Object Lock governance retention

## Policy as Code

The policy suite is located at policies/capstone_governance.rego.

The policy gate validates:

- Customer-managed KMS key exists
- S3 uploads bucket uses SSE-KMS
- S3 uploads bucket versioning is enabled
- S3 uploads bucket TLS-only policy exists
- DynamoDB encryption is configured
- DynamoDB point-in-time recovery is enabled
- Lambda is configured inside the VPC
- Lambda X-Ray tracing is active
- CloudTrail is multi-region
- CloudTrail log file validation is enabled
- Evidence vault Object Lock is configured
- Evidence vault encryption is configured

Run locally:

bash scripts/capstone-policy-gate.sh terraform policies evidence/capstone

Policy evidence:

- evidence/capstone/capstone-plan.json
- evidence/capstone/capstone-conftest-results.json

## GitHub Actions Workflow

The capstone workflow is located at .github/workflows/capstone-grc-gate.yml.

The workflow performs Terraform setup, Terraform format validation, Terraform initialization, Terraform validation, Conftest policy evaluation, workflow evidence bundle creation, and workflow artifact upload.

Latest validated workflow run used for signed evidence: 26009609442

## Signed Evidence and Chain of Custody

The final capstone evidence bundle was packaged locally, hashed with SHA-256, signed with Cosign keyless signing, uploaded to the S3 evidence vault, documented with a receipt, verified using SHA-256 and Cosign, and protected with S3 Object Lock governance retention.

S3 evidence vault location:

s3://acme-health-intake-evidence-c197281c/capstone/runs/26009609442/

Signed evidence metadata is stored in evidence/capstone-signed/.

Key evidence files:

| File | Purpose |
|---|---|
| receipt.json | Records run ID, vault, bundle key, SHA-256 hash, commit, workflow, signing method, and upload time |
| vault-listing.txt | Shows uploaded bundle, hash, signature bundle, and receipt in S3 |
| sha256-verification.txt | Confirms local SHA-256 verification passed |
| cosign-verification.txt | Confirms Cosign signature verification passed |
| object-retention.json | Confirms S3 Object Lock governance retention |
| signed-evidence-summary.md | Summarizes the signed evidence chain |

## OSCAL

The OSCAL component definition is located at oscal/component-definitions/acme-health-intake/component-definition.json.

The OSCAL artifact maps selected HIPAA Security Rule safeguards to implemented technical controls and evidence links.

| HIPAA Safeguard | Capstone Implementation |
|---|---|
| 164.312(a)(2)(iv) | Customer-managed encryption for PHI-related data stores |
| 164.312(b) | Audit controls through CloudTrail and workflow evidence |
| 164.312(c)(1) | Integrity controls through Object Lock, hashing, signing, and receipt metadata |
| 164.312(e)(1) | Transmission security through TLS-only policies and private service access |

OSCAL validation evidence is stored at evidence/capstone/oscal-json-validation.txt.

## Validation Results

| Validation Area | Result |
|---|---|
| Starter deploy gate | Passed |
| Initial smoke test | Passed |
| Governance baseline apply | Passed |
| Post-governance smoke test | Passed |
| Terraform clean plan | Passed |
| Rego policy gate | Passed |
| GitHub Actions workflow | Passed |
| SHA-256 verification | Passed |
| Cosign verification | Passed |
| S3 Object Lock retention check | Passed |
| OSCAL JSON parse validation | Passed |

## Key Evidence Locations

- evidence/deploy-gate/
- evidence/capstone/
- evidence/capstone-signed/
- oscal/component-definitions/acme-health-intake/
- WRITEUP.md

## Trade-Offs

Reserved Lambda concurrency was not enforced because the AWS sandbox account returned a service quota error. The error indicated that reserving concurrency would reduce unreserved account concurrency below the AWS minimum. This was documented as a capstone trade-off.

The evidence vault is in the same AWS sandbox account as the workload. A stronger production architecture would use a separate audit or security account for evidence storage and retention.

The final signed evidence upload was performed locally using Cosign keyless signing. In a production version, this would be moved fully into GitHub Actions with OIDC-based AWS access.

## Final Write-Up

The full capstone explanation is available in WRITEUP.md.

## Current Status

| Area | Status |
|---|---|
| Capstone governance baseline | Complete |
| Policy-as-code gate | Complete |
| GitHub Actions workflow | Complete |
| Signed evidence bundle | Complete |
| S3 evidence vault upload | Complete |
| OSCAL component definition | Complete |
| Final write-up | Complete |
