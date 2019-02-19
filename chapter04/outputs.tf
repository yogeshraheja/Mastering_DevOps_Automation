output "ssh_bastion_public_ip" {
    value = "${module.vpc.aws_ssh_bastion_public_ip}"
}
