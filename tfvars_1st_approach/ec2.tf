resource "aws_instance" "ec2" {
    for_each = var.instance_type
    ami=var.ami_id
    instance_type=each.value
    vpc_security_group_ids= ["sg-0f0225d73ad9227cc"]
    tags = {
      Name= each.key
    }
}