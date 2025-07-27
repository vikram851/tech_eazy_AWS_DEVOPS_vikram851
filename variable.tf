
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}


variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  description = "ubuntu"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  default     = "ami-053b0d53c279acc90" # Ubuntu 22.04 for us-east-1
}

variable "repo_url" {
  default = "https://github.com/Trainings-TechEazy/test-repo-for-devops"
}

variable "key_name" {
  description = "key_name"
  type = string
  sensitive = true
}

variable "environment" {
  description = "Dev or Prod"
  default     = "dev"
}

variable "s3_bucket_name" {
description = "s3_bucket_name"
type = string
sensitive = true
}
