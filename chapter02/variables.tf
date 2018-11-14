variable "aws_vpc" {
    type = "map"

    default = {
        id = ""
    }
}

variable "aws_subnet" {
    type = "map"

    default = {
        availability_zone = ""
    }
}

variable "aws_instance" {
    type = "map"

    default = {
        instance_type = ""
        key_name = ""
    }
}

