module "vpc" {
    source = "./vpc-example"

    aws_vpc = {
        name = "${var.aws_vpc["name"]}"
        cidr_block = "${var.aws_vpc["cidr_block"]}"
        enable_dns_support = "${var.aws_vpc["enable_dns_support"]}"
        enable_dns_hostnames = "${var.aws_vpc["enable_dns_hostnames"]}"
    }

    aws_subnet = {
        availability_zones = "${var.aws_subnet["availability_zones"]}"

        pub_alb_cidr_blocks = "${var.aws_subnet["pub_alb_cidr_blocks"]}"
        pub_ec2_cidr_blocks = "${var.aws_subnet["pub_ec2_cidr_blocks"]}"
        pub_dmz_cidr_blocks = "${var.aws_subnet["pub_dmz_cidr_blocks"]}"

        pub_rds_cidr_blocks = []
        prv_alb_cidr_blocks = []
        prv_ec2_cidr_blocks = []
        prv_rds_cidr_blocks = []
    }

    aws_instance = {
        instance_type = "${var.aws_instance["instance_type"]}"
        ami = "${var.aws_instance["ami"]}"
        key_name = "${var.aws_instance["key_name"]}"
    }

    aws_security_group = {
        bastion_cidr_blocks = "${var.aws_security_group["bastion_cidr_blocks"]}"
    }
}
