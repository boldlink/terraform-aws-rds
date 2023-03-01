variable "supporting_resources_name" {
  type        = string
  description = "The stack name for supporting resources launched separately"
  default     = "terraform-aws-rds"
}

variable "name" {
  type        = string
  description = "The stack name"
  default     = "exampleinstancepostgresql"
}

variable "tags" {
  type        = map(string)
  description = "The resource tags to be applied"
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    Department         = "DevOps"
    Project            = "Examples"
    InstanceScheduler  = true
    Owner              = "Boldlink"
    LayerName          = "Example"
    LayerId            = "Example"
  }
}
