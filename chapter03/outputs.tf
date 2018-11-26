output "aws_ssh_bastion_public_ip" {
    value = "${aws_eip.bastion.public_ip}"
}

