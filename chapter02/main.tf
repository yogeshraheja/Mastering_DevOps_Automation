provider "aws" {
}

resource "aws_security_group" "ssh" {
    vpc_id = "${var.aws_vpc["id"]}"
    name = "SSH connection"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags {
        Name = "Mastering DevOps Automation server SSH connection"
    }
}

resource "aws_instance" "server" {
    instance_type = "${var.aws_instance["instance_type"]}"
    key_name = "${var.aws_instance["key_name"]}"
    ami = "${data.aws_ami.ubuntu.id}"

    vpc_security_group_ids = [ "${aws_security_group.ssh.id}" ]
    subnet_id = "${data.aws_subnet.us-east-1a.id}"

    tags {
        Name = "mastering-devops-automation"
    }
}

