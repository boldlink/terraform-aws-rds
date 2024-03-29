locals {
  vpc_id   = data.aws_vpc.supporting.id
  vpc_cidr = data.aws_vpc.supporting.cidr_block
  tags     = merge({ "Name" = var.db_name }, var.tags)
  database_subnets = [
    for s in data.aws_subnet.database : s.id
  ]
}
