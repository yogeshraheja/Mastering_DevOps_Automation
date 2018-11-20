aws_vpc = {
   name = "mastering-devops-automation"
   cidr_block = "10.0.0.0/16"
   enable_dns_support = "true"
   enable_dns_hostnames = "true"
}

aws_subnet = {
   availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

   pub_alb_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
   prv_alb_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
   pub_ec2_cidr_blocks = ["10.0.6.0/24", "10.0.8.0/24", "10.0.10.0/24"]
   prv_ec2_cidr_blocks = ["10.0.7.0/24", "10.0.9.0/24", "10.0.11.0/24"]
   pub_rds_cidr_blocks = ["10.0.12.0/24", "10.0.14.0/24", "10.0.16.0/24"]
   prv_rds_cidr_blocks = ["10.0.13.0/24", "10.0.15.0/24", "10.0.17.0/24"]

   pub_dmz_cidr_blocks = ["10.0.18.0/24", "10.0.20.0/24", "10.0.22.0/24"]
}

aws_instance = {
    instance_type = "t2.nano"
    ami = "ami-0ac019f4fcb7cb7e6"
    key_name = "mastering-devops-automation"
}

aws_security_group = {
    bastion_cidr_blocks = ["0.0.0.0/0"]
}

