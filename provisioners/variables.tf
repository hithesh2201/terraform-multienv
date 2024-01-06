variable "ami_id" {
  type=string
  default="ami-03265a0778a880afb"
  
}


variable "domain_path" {

  default = "hiteshshop.online"
}

variable "hosted_zone_id" {
  default = "Z0781952344MQ4MZCJ506"
}
variable "instance" {
  default = {
    mongod     = "t3.small"  #key= value
    mysql      = "t3.small"
    shipping   = "t3.small"
    user    = "t2.micro"
    cart    = "t2.micro"
    catalogue    = "t2.micro"
    redis    = "t2.micro"
    web    = "t2.micro"
    rabbitmq    = "t2.micro"
    payment    = "t2.micro"
    dispatch    = "t2.micro"
  }
}