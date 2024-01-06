resource "aws_instance" "ec2" {
    ami=var.ami_id
    instance_type="t2.micro"
    vpc_security_group_ids= ["sg-0f0225d73ad9227cc"]
    tags = {
      Name= "provisioner"
    }
    provisioner "local-exec" {
    command = "echo ${self.public_ip} >> private_ips.txt"
  }
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo yum install ansible -y",
        "git clone https://github.com/hithesh2201/ansible.git ",
        "cd ansible",
        "ansible-playbook 01-playbook.yaml"

    ]
  }
}