variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-southeast-2"
}

variable "key_name1" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "key_name2" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "admin_cidr" {
  description = "Your public IP address in CIDR notation for SSH access"
  type        = string
  default     = "YOUR_IP/32"
}
