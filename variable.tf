variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "My_Instance"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-07ff62358b87c7116" # Amazon Linux 2 in us-east-1
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
  default     = "New_Amazon"
}

variable "existing_vpc_id" {
  description = "ID of the existing VPC"
  type        = string
  default = "vpc-0773dde7ddccc56fd"
}

variable "existing_subnet_id" {
  description = "ID of the existing public subnet"
  type        = string
  default = "subnet-08066e49ea7c26e37"
}

variable "existing_security_group_ids" {
  description = "List of existing security group IDs to attach"
  type        = list(string)
  default     = ["sg-04735de3bd9454ef2"]
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP to the instance"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}