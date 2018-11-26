provider "aws" {
}

resource "aws_vpc" "vpc" {
    cidr_block = "${var.aws_vpc["cidr_block"]}"
    enable_dns_support = "${var.aws_vpc["enable_dns_support"]}"
    enable_dns_hostnames = "${var.aws_vpc["enable_dns_hostnames"]}"

    tags {
        Name = "${var.aws_vpc["name"]}"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "${var.aws_vpc["name"]}_igw"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_eip" "eip_nat" {
    count = "${length(var.aws_subnet["pub_dmz_cidr_blocks"])}"

    vpc = true

    depends_on = [ "aws_internet_gateway.default" ]
}

resource "aws_nat_gateway" "default" {
    count = "${length(var.aws_subnet["pub_dmz_cidr_blocks"])}"

    allocation_id = "${element(aws_eip.eip_nat.*.id, count.index)}"
    subnet_id = "${element(aws_subnet.pub-dmz.*.id, count.index)}"

    depends_on = [ "aws_internet_gateway.default" ]
}

resource "aws_route_table" "pub" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.aws_vpc["name"]}_rt_pub"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_subnet" "pub-alb" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["pub_alb_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["pub_alb_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"
    map_public_ip_on_launch = "true"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_pub-alb"
        Type = "public"
        Kind = "alb"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_subnet" "pub-ec2" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["pub_ec2_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["pub_ec2_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"
    map_public_ip_on_launch = "true"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_pub-ec2"
        Type = "public"
        Kind = "ec2"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_subnet" "pub-rds" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["pub_rds_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["pub_rds_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"
    map_public_ip_on_launch = "true"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_pub_rds"
        Type = "public"
        Kind = "rds"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_subnet" "pub-dmz" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["pub_dmz_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["pub_dmz_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"
    map_public_ip_on_launch = "true"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_pub-dmz"
        Type = "public"
        Kind = "dmz"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_route_table_association" "pub-alb" {
    count = "${aws_subnet.pub-alb.count}"

    subnet_id = "${element(aws_subnet.pub-alb.*.id, count.index)}"
    route_table_id = "${aws_route_table.pub.id}"
}

resource "aws_route_table_association" "pub-ec2" {
    count = "${aws_subnet.pub-ec2.count}"

    subnet_id = "${element(aws_subnet.pub-ec2.*.id, count.index)}"
    route_table_id = "${aws_route_table.pub.id}"
}

resource "aws_route_table_association" "pub-rds" {
    count = "${aws_subnet.pub-rds.count}"

    subnet_id = "${element(aws_subnet.pub-rds.*.id, count.index)}"
    route_table_id = "${aws_route_table.pub.id}"
}

resource "aws_route_table_association" "pub-dmz" {
    count = "${aws_subnet.pub-dmz.count}"

    subnet_id = "${element(aws_subnet.pub-dmz.*.id, count.index)}"
    route_table_id = "${aws_route_table.pub.id}"
}

resource "aws_route_table" "prv" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${aws_nat_gateway.default.count}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${element(aws_nat_gateway.default.*.id, count.index)}"
    }

    tags {
        Name = "${var.aws_vpc["name"]}_rt_prv"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }

    depends_on = [ "aws_nat_gateway.default" ]
}

resource "aws_subnet" "prv-alb" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["prv_alb_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["prv_alb_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_prv_alb"
        Type = "private"
        Kind = "alb"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_subnet" "prv-ec2" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["prv_ec2_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["prv_ec2_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_prv_ec2"
        Type = "private"
        Kind = "ec2"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_subnet" "prv-rds" {
    vpc_id = "${aws_vpc.vpc.id}"

    count = "${length(var.aws_subnet["prv_rds_cidr_blocks"])}"

    cidr_block = "${element(var.aws_subnet["prv_rds_cidr_blocks"], count.index)}"
    availability_zone = "${element(var.aws_subnet["availability_zones"], count.index)}"

    tags {
        Name = "${element(var.aws_subnet["availability_zones"], count.index)}_prv_rds"
        Type = "private"
        Kind = "rds"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_route_table_association" "prv-alb" {
    count = "${aws_subnet.prv-alb.count}"

    subnet_id = "${element(aws_subnet.prv-alb.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.prv.*.id, count.index)}"
}

resource "aws_route_table_association" "prv-ec2" {
    count = "${aws_subnet.prv-ec2.count}"

    subnet_id = "${element(aws_subnet.prv-ec2.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.prv.*.id, count.index)}"
}

resource "aws_route_table_association" "prv-rds" {
    count = "${aws_subnet.prv-rds.count}"

    subnet_id = "${element(aws_subnet.prv-rds.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.prv.*.id, count.index)}"
}

resource "aws_security_group" "internal" {
    name = "Internal SSH"
    description = "Allows access from bastion to internal servers"
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${aws_instance.bastion.private_ip}/32" ]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags {
        Name = "Internal from bastion"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }

    depends_on = [ "aws_instance.bastion" ]
}

resource "aws_eip" "bastion" {
    vpc = true
    instance = "${aws_instance.bastion.id}"
}

resource "aws_security_group" "bastion" {
    name = "Bastion"
    description = "Allows access from world to bastion"
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${var.aws_security_group["bastion_cidr_blocks"]}" ]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${aws_vpc.vpc.cidr_block}" ]
    }

    tags {
        Name = "Bastion"
        VirtualNetwork = "${aws_vpc.vpc.tags.Name}"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }
}

resource "aws_instance" "bastion" {
    instance_type = "${var.aws_instance["instance_type"]}"
    ami = "${var.aws_instance["ami"]}"
    key_name = "${var.aws_instance["key_name"]}"

    subnet_id = "${aws_subnet.pub-dmz.1.id}"
    vpc_security_group_ids = [ "${aws_security_group.bastion.id}" ]

    disable_api_termination = true

    tags {
        Name = "ssh-bastion"
        VirtualNetwork = "${aws_vpc.vpc.tags.Name}"
        Environment = "${terraform.workspace}"
        CreatedBy = "terraform"
    }

    depends_on = [ "aws_security_group.bastion", "aws_subnet.pub-dmz" ]
}

