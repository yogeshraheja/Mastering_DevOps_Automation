output "aws_alb_dns_name" {
    value = "${aws_alb.alb.dns_name}"
}

output "aws_instance_public_ips" {
    value = "${aws_instance.ec2.*.public_ip}"
}

