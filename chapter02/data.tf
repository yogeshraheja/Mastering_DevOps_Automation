data "aws_subnet" "us-east-1a" {
    vpc_id = "${var.aws_vpc["id"]}"
    availability_zone = "${var.aws_subnet["availability_zone"]}"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = [ "099720109477" ]

    filter {
        name = "name"
        values = [ "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*" ]
    }

    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }
}
