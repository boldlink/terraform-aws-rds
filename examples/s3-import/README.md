[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-rds/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-rds.svg)](https://github.com/boldlink/terraform-aws-rds/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Terraform module usage example with s3-import

### Backup/Restore Requirements:
- Only backups created with [Percona XtraBackup](https://www.percona.com/downloads) are accepted. `.sql` dump files are not supported.
- The tar compression program must be installed on the environment where you will be running Terraform deployments for this example.
- Creating backups of AWS RDS instances using Percona XtraBackup is not feasible, as the process necessitates access to the underlying database files, which is not viable with RDS. This limitation arises from the fact that RDS is a fully-managed service offered by AWS.

#### MySQL Version Compatibility:
- Ensure that the version of MySQL you are using for RDS matches the version of MySQL used to create the backup. The backup for this example was taken using version `8.0.32`.

See [here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Procedural.Importing.html) how to create a database backup using Percona XtraBackup.

### Sample Database and tables created from backup
- In this example, we have instantiated a database named `usersdb`. Within this database, we have defined a table named `users`, which comprises three fields: `name, age, and address`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.15.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.19.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_create_from_s3_import"></a> [rds\_create\_from\_s3\_import](#module\_rds\_create\_from\_s3\_import) | ../../ | n/a |
| <a name="module_s3_bucket_for_mysql_import"></a> [s3\_bucket\_for\_mysql\_import](#module\_s3\_bucket\_for\_mysql\_import) | boldlink/s3/aws | 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.s3_acces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.s3_acces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [random_string.rds_usr](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_alias.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Create an IAM role for enhanced monitoring | `bool` | `true` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of the database | `string` | `"examples3db"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false. | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs. | `list(string)` | <pre>[<br>  "general",<br>  "error",<br>  "slowquery"<br>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use. | `string` | `"mysql"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Choose whether to force deletion of non empty bucket | `bool` | `true` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled | `bool` | `true` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance class for your instance(s). | `string` | `"db.t2.small"` | no |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | Specify the major version of the engine that this option group should be associated with. | `string` | `"8.0"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. | `number` | `30` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Boolean if specified leave availability\_zone empty, default = false | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the stack | `string` | `"mysql-s3-import-examples"` | no |
| <a name="input_option_name"></a> [option\_name](#input\_option\_name) | Name for option group option | `string` | `"MARIADB_AUDIT_PLUGIN"` | no |
| <a name="input_source_engine_version"></a> [source\_engine\_version](#input\_source\_engine\_version) | Version of the source engine used to make the backup | `string` | `"8.0.32"` | no |
| <a name="input_sse_bucket_key_enabled"></a> [sse\_bucket\_key\_enabled](#input\_sse\_bucket\_key\_enabled) | Specify whether Server side encryption is enabled | `bool` | `false` | no |
| <a name="input_sse_sse_algorithm"></a> [sse\_sse\_algorithm](#input\_sse\_sse\_algorithm) | Encryption algorithm for the s3 bucket | `string` | `"AES256"` | no |
| <a name="input_supporting_resources_name"></a> [supporting\_resources\_name](#input\_supporting\_resources\_name) | The stack name for supporting resources launched separately | `string` | `"terraform-aws-rds"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The resource tags to be applied | `map(string)` | <pre>{<br>  "Department": "DevOps",<br>  "Environment": "example",<br>  "InstanceScheduler": true,<br>  "LayerId": "Example",<br>  "LayerName": "Example",<br>  "Owner": "hugo.almeida",<br>  "Project": "Examples",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

#### BOLDLink-SIG 2023
