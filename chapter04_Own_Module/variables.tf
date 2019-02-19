variable "aws_vpc" {
    type = "map"

    default = {
        cidr_block = ""
        enable_dns_support = ""
        enable_dns_hostnames = ""
    }
}

variable "aws_subnet" {
    type = "map"

    default = {
        availability_zones = []

        pub_alb_cidr_blocks = []
        pub_ec2_cidr_blocks = []
        pub_dmz_cidr_blocks = []
    }
}

variable "aws_instance" {
    type = "map"

    default = {
        instance_type = ""
        ami = ""
        key_name = ""
        volume_size = 0
    }
}

variable "aws_security_group" {
    type = "map"

    default = {
        bastion_cidr_blocks = []
    }
}
