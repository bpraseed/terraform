
variable "ec2_keypair_name" { 
  description = "EC2 key pair name"
}

variable "owner_tag" {
  description = "Owner tag to identify your instance"
}

variable "AWS_DEFAULT_REGION"     { 
  description = "AWS region"
  default     = "us-west-1" 
}

variable "security_group" {
	description = "Security group id starting with sg-.."
	default     = "sg-f71ab893" 
}

variable "subnet_id" {
	description = "Subnet of VPC eg: subnet-.."
	default     = "subnet-f2b1f3ab" 
}

variable "type" {
  description = "AWS Instance type to deploy for each Cloudera cluster role."
  default {
    "cloudera_manager" = "m4.xlarge"
    "datanode" = "r4.xlarge"
    "cdsw_service" = "m4.4xlarge"
  }
}


variable "amis" {
  description = "AMI to launch the instances with"
  default = {
    us-west-1-centos_72 = "ami-af4333cf"
    us-west-1-rhel_72 = "ami-f7eb9b97"  
  }
}



