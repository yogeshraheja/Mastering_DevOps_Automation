variable "aws_vpc" {
    type = "map"

    default = {
        id = ""
    }
}

variable "aws_subnet" {
    type = "map"

    default = {
        alb_ids = []
        ec2_ids = []
    }
}

variable "aws_instance" {
    type = "map"

    default = {
        count = 0
        instance_type = ""
        ami = ""
        key_name = ""
        volume_size = 0
    }
}

variable "aws_security_group" {
    type = "map"

    default = {
        internal_id = []
        alb_cidr_blocks = []
        ec2_cidr_blocks = []
    }
}

variable "aws_alb" {
    type = "map"

    default = {
        name = ""
    }
}

