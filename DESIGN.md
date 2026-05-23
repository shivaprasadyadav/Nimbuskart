# Design Decisions

## Why LocalStack
LocalStack was used to simulate AWS services locally and avoid real AWS costs during development and testing.

## Terraform Modules
Terraform modules were used for reusable and organized infrastructure code.

## Tagging Strategy
All resources include standard tags:
- Project
- Environment
- Owner
- ManagedBy

## Security Decisions
- Public subnets used for simplicity
- SSH port open for testing purposes only
- Real production should use private subnets and restricted SSH access

## Janitor Logic
The janitor script identifies orphan EBS volumes by checking resources without active attachments.

## Tradeoffs
S3 lifecycle configuration was excluded from runtime validation because of LocalStack API limitations.
