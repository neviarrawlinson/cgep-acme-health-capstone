# Capstone Design Decisions

## Scenario

Acme Health is a 50-person telehealth company with a Patient Intake API that handles patient intake submissions. Because the workload may process protected health information, the system needs to become audit-defensible without slowing down the engineering team.

## Primary Framework

Primary framework: HIPAA Security Rule

I selected the HIPAA Security Rule as the primary framework because the capstone workload is a telehealth Patient Intake API and the most important risk is protection of PHI. SOC 2 and CMMC are relevant secondary considerations, but HIPAA is the most directly aligned to the system purpose and data classification.

## AWS Region

Region: us-east-1

The starter workload deployed successfully in us-east-1, and this region will be used consistently for the capstone baseline, evidence vault, CloudTrail, and pipeline validation.

## Object Lock Mode

Evidence vault Object Lock mode: GOVERNANCE

Governance mode is selected for the capstone because it provides retention protection for evidence while still allowing authorized administrative cleanup in a sandbox learning environment. In a production audit environment, Compliance mode may be more appropriate depending on legal and retention requirements.

## Pipeline Model

Pipeline model: apply on merge to main

Pull requests will run Terraform plan and policy checks. Merges to main will apply approved infrastructure, sign the evidence bundle with Cosign, and upload the signed evidence to the S3 evidence vault.

## Account Model

Account model: single AWS sandbox account

A separate evidence account would provide stronger separation of duties, but the 30-day capstone timeline and sandbox constraints make a single account acceptable. The evidence vault will still use encryption, versioning, Object Lock, and signed evidence bundles.

## Initial Gap Closure Strategy

The capstone will prioritize the most material HIPAA-aligned technical gaps:

| Gap | Planned Treatment |
|---|---|
| GAP-01 S3 SSE-KMS with CMK | Terraform remediation and Rego policy |
| GAP-02 DynamoDB CMK encryption | Terraform remediation and Rego policy |
| GAP-03 S3 deny non-TLS requests | Terraform remediation and Rego policy |
| GAP-04 S3 versioning | Terraform remediation and Rego policy |
| GAP-05 Lambda VPC configuration | Terraform remediation and Rego policy |
| GAP-07 Least privilege IAM for Lambda | Terraform remediation and Rego policy |

GAP-06 and GAP-08 may be included as stretch controls if time allows.
