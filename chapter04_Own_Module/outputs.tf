output "ssh_bastion_public_ip" {
    value = "${module.vpc.aws_ssh_bastion_public_ip}"
}

output "aws_alb_dns_name" {
    value = "${module.alb-ec2.aws_alb_dns_name}"
}

output "aws_instance_public_ips" {
    value = "${module.alb-ec2.aws_instance_public_ips}"
}

