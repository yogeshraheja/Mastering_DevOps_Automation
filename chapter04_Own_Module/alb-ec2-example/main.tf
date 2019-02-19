resource "aws_alb" "alb" {
    name = "${var.aws_alb["name"]}"
    internal = "${var.aws_alb["internal"]}"
    security_groups = [ "${aws_security_group.alb.id}" ]
    subnets = [ "${var.aws_subnet["alb_ids"]}" ]

    enable_deletion_protection = false

    tags {
        Name = "${var.aws_alb["name"]}"
        CreatedBy = "terraform"
        Environent = "${terraform.workspace}"
    }
}

resource "aws_alb_target_group" "alb-tg-http" {
    name = "${var.aws_alb["name"]}-http"
    port = 80
    protocol = "HTTP"
    vpc_id = "${var.aws_vpc["id"]}"

    health_check {
        interval = 30
        port = 80
        path = "/"
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 5
        protocol = "HTTP"
        matcher = "200"
    }
}

resource "aws_alb_target_group_attachment" "http" {
    count = "${aws_instance.ec2.count}"

    target_group_arn = "${aws_alb_target_group.alb-tg-http.arn}"
    target_id = "${element(aws_instance.ec2.*.id, count.index)}"
    port = 80
}

resource "aws_alb_listener" "front_end_http" {
    load_balancer_arn = "${aws_alb.alb.arn}"
    port = 80
    protocol = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.alb-tg-http.id}"
        type = "forward"
    }
}

resource "aws_security_group" "alb" {
    name = "${var.aws_alb["name"]}-alb-sg"
    vpc_id = "${var.aws_vpc["id"]}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "${var.aws_security_group["alb_cidr_blocks"]}" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags {
        Name = "${var.aws_alb["name"]}-alb"
        CreatedBy = "terraform"
        Environent = "${terraform.workspace}"
    }
}

resource "aws_security_group" "ec2" {
    name = "${var.aws_alb["name"]}-ec2-sg"
    vpc_id = "${var.aws_vpc["id"]}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "${var.aws_security_group["ec2_cidr_blocks"]}" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags {
        Name = "${var.aws_alb["name"]}-ec2"
        CreatedBy = "terraform"
        Environent = "${terraform.workspace}"
    }
}

resource "aws_instance" "ec2" {
    count = "${var.aws_instance["count"]}"

    instance_type = "${var.aws_instance["instance_type"]}"
    key_name = "${var.aws_instance["key_name"]}"
    ami = "${var.aws_instance["ami"]}"

    subnet_id = "${element(var.aws_subnet["ec2_ids"], count.index)}"
    vpc_security_group_ids = [ "${var.aws_security_group["internal_id"]}", "${aws_security_group.ec2.id}" ]
    disable_api_termination = false

    root_block_device {
        volume_type = "gp2"
        volume_size = "${var.aws_instance["volume_size"]}"
        delete_on_termination = "true"
    }

    tags {
        Name = "mastering-devops-${count.index}"
        CreatedBy = "terraform"
        Environent = "${terraform.workspace}"
    }
}

