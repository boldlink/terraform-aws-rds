locals {
  vpc_id             = data.aws_vpc.supporting.id
  partition          = data.aws_partition.current.partition
  dns_suffix         = data.aws_partition.current.dns_suffix
  replication_bucket = "${var.name}-replication-bucket"
  tags               = merge({ "Name" = var.name }, var.tags)

  database_subnets = [
    for s in data.aws_subnet.database : s.id
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "s3.${local.dns_suffix}"
        },
        "Effect" : "Allow",
        "Sid" : "AllowS3AssumeRole"
      }
    ]
  })

  role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectVersion",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Effect" : "Allow",
        "Resource" : [
          module.replication_bucket.arn,
          "${module.replication_bucket.arn}/*",
          "arn:${local.partition}:s3:::${var.name}",
          "arn:${local.partition}:s3:::${var.name}/*"
        ]
      },
      {
        "Action" : [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${module.replication_bucket.arn}/*",
          "arn:${local.partition}:s3:::${var.name}/*"
        ]
      }
    ]
  })
}
