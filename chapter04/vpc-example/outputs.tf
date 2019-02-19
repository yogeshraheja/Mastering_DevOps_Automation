output "aws_vpc_id" {
    value = "${aws_vpc.vpc.id}"
}

output "aws_subnet_pub_alb_ids" {
    value = "${aws_subnet.pub-alb.*.id}"
}

output "aws_subnet_pub_ec2_ids" {
    value = "${aws_subnet.pub-ec2.*.id}"
}

output "aws_security_group_internal_id" {
    value = "${aws_security_group.internal.id}"
}

output "aws_ssh_bastion_public_ip" {
    value = "${aws_instance.bastion.public_ip}"
}
