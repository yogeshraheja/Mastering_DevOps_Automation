output "aws_ssh_bastion_public_ip" {
    value = "${aws_instance.bastion.public_ip}"
}

