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
module "alb-ec2" {
    source = "./alb-ec2-example"

    aws_vpc = {
        id = "${module.vpc.aws_vpc_id}"
    }

    aws_subnet = {
        alb_ids = "${module.vpc.aws_subnet_pub_alb_ids}"
        ec2_ids = "${module.vpc.aws_subnet_pub_ec2_ids}"
    }

    aws_instance = {
        count = "${length(var.aws_subnet["pub_ec2_cidr_blocks"])}"
        instance_type = "${var.aws_instance["instance_type"]}"
        ami = "${var.aws_instance["ami"]}"
        key_name = "${var.aws_instance["key_name"]}"
        volume_size = "${var.aws_instance["volume_size"]}"
    }

    aws_security_group = {
        internal_id = [ "${module.vpc.aws_security_group_internal_id}" ]

        alb_cidr_blocks = [ "${var.aws_security_group["alb_cidr_blocks"]}" ]
        ec2_cidr_blocks = [ "${var.aws_security_group["ec2_cidr_blocks"]}" ]
    }

    aws_alb = {
        name = "${var.aws_alb["name"]}"
        internal = "${var.aws_alb["internal"]}"
    }
}

