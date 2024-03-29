locals {
  vpc_id     = data.aws_vpc.supporting.id
  vpc_cidr   = data.aws_vpc.supporting.cidr_block
  partition  = data.aws_partition.current.partition
  tags       = merge({ "Name" = var.name }, var.tags)
  dns_suffix = data.aws_partition.current.dns_suffix

  database_subnets = [
    for s in data.aws_subnet.database : s.id
  ]
}
