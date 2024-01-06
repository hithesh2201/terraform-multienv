resource "aws_instance" "roboshop" {
  # count= length(var.instances_name)
  for_each = var.instance  
  ami           = "ami-03265a0778a880afb"
  instance_type = each.value
  vpc_security_group_ids = ["sg-0f0225d73ad9227cc"]

   tags = merge(
                {Name = "${each.key}-dev"},
                local.common_tags      # { {},{},{},{}}
                )
}
resource "aws_route53_record" "www" {
  # count   = length(var.instances_name)
  for_each = aws_instance.roboshop
  zone_id = var.hosted_zone_id
  name    = each.key != "web" ? "${each.key}.${var.domain_path}" : "${var.domain_path}"
  type    = "A" #ipv4 address
  ttl     = 1
  records = [each.key == "web" ? each.value.public_ip : each.value.private_ip]
}


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

  provisioner "remote-exec" {            # terraform apply -refresh=true
    inline = [          #git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch largefiles/*' --prune-empty --tag-name-filter cat -- --all

        "sudo yum install ansible -y",
        "git clone https://github.com/hithesh2201/ansible-roles.git ",
        "cd ansible-roles",
        "ansible-playbook -e component=mongod main.yaml", 
        "ansible-playbook -e component=catalogue main.yaml",
        "ansible-playbook -e component=web main.yaml",
        "ansible-playbook -e component=user main.yaml",
        "ansible-playbook -e component=redis main.yaml",
        "ansible-playbook -e component=cart main.yaml",
        "ansible-playbook -e component=mysql main.yaml",
        "ansible-playbook -e component=shipping main.yaml",
        "ansible-playbook -e component=rabbitmq main.yaml",
        "ansible-playbook -e component=payment main.yaml",
        "ansible-playbook -e component=dispatch main.yaml"

    ]
  }
}