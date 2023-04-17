# VPC Input Variables

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
}

# VPC Availability Zones
#variable "vpc_availability_zones" {
#  description = "A list of availability zones names or ids in the region"
#  type        = list(string)
#}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
}

# VPC Enable DNS Hostnames (True or False)
variable "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  type        = bool
}

# VPC Enable DNS Support (True or False)
variable "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  type        = bool
}