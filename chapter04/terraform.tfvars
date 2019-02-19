aws_vpc = {
    name = "terraform-modules-example"
    cidr_block = "172.30.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
}

aws_subnet = {
    availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]

    pub_alb_cidr_blocks = [ "172.30.0.0/24", "172.30.2.0/24", "172.30.4.0/24" ]
    pub_ec2_cidr_blocks = [ "172.30.6.0/24", "172.30.8.0/24", "172.30.10.0/24" ]
    pub_dmz_cidr_blocks = [ "172.30.12.0/24", "172.30.14.0/24", "172.30.16.0/24" ]
}

aws_instance = {
    instance_type = "t2.nano"
    ami = "ami-cd0f5cb6"
    key_name = "mastering-devops-automation"
    volume_size = 10
}
