resource "aws_instance" "ec2" {
    ami=var.ami_id
    instance_type=lookup(var.instance_type,terraform.workspace)
    vpc_security_group_ids= ["sg-0f0225d73ad9227cc"]
    tags = {
      Name= terraform.workspace
    }
}