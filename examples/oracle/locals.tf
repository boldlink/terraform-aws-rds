locals {
  vpc_id           = data.aws_vpc.supporting.id
  database_subnets = local.database_subnet_id
  partition        = data.aws_partition.current.partition
  database_subnet_id = [
    for s in data.aws_subnet.database : s.id
  ]
}
