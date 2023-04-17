# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources are going to be created"
  type        = string
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

# Business Division
variable "business_division" {
  description = "Business Division this Infrastructure belongs"
  type        = string
}

# Master Role
variable "master_role" {
  description = "Master Role for kubectl"
  type        = string
}

# Master Username
variable "user_name" {
  description = "Master Username for kubectl"
  type        = string
}