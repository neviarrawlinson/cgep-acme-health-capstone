# OSCAL Capstone Artifacts

This folder contains the OSCAL component definition for the Acme Health Patient Intake API capstone.

## Artifact

```text
oscal/component-definitions/acme-health-intake/component-definition.json
```

## Purpose

The OSCAL component definition documents how the governed Patient Intake API implements selected HIPAA Security Rule safeguards and links those safeguards to evidence captured during the capstone.

## Primary Framework

Primary framework: HIPAA Security Rule

## Controls Represented

| HIPAA Safeguard | Capstone Implementation | Evidence |
|---|---|---|
| 164.312(a)(2)(iv) | Customer-managed KMS encryption for PHI-related data stores | S3, DynamoDB, KMS, signed bundle evidence |
| 164.312(b) | Audit controls through CloudTrail and workflow evidence | CloudTrail status and Terraform evidence |
| 164.312(c)(1) | Integrity controls through Object Lock, hashing, signing, and receipt metadata | SHA-256, Cosign, receipt, retention evidence |
| 164.312(e)(1) | Transmission security through TLS-only policies and private service access | S3 bucket policy and Lambda VPC evidence |

## Evidence Chain

The OSCAL artifact links implemented requirements to the signed capstone evidence bundle stored in the S3 evidence vault.

```text
s3://acme-health-intake-evidence-c197281c/capstone/runs/26009609442/
```
