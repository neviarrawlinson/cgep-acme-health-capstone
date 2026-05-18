# Capstone Policy-as-Code Suite

This folder contains Rego policies used to evaluate the Acme Health Patient Intake API Terraform plan.

## Policy Scope

The policy suite validates the Layer 1 governance baseline:

| Gap or Control Area | Policy Expectation |
|---|---|
| GAP-01 | Uploads bucket must use SSE-KMS |
| GAP-02 | DynamoDB must use customer-managed encryption |
| GAP-03 | Uploads bucket must have a TLS-only deny policy |
| GAP-04 | Uploads bucket versioning must be enabled |
| GAP-05 | Lambda must run inside the VPC |
| GAP-06 | Lambda tracing must be active |
| GAP-07 | Lambda IAM must be least-privilege and include required KMS access |
| Audit Controls | CloudTrail must be multi-region and use log file validation |
| Evidence Integrity | Evidence vault must use encryption, versioning, and Object Lock governance retention |

## Evidence Output

The policy gate produces:

```text
evidence/capstone/capstone-plan.json
evidence/capstone/capstone-conftest-results.json
```

## Run Locally

```bash
bash scripts/capstone-policy-gate.sh terraform policies evidence/capstone
```

## Purpose

This policy suite proves that the capstone governance baseline can be evaluated automatically before changes are merged or deployed.
