variable "ec2_settings" {
  default = {
    ami                         = "ami-0ca8fb22bc38a4ca2"
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    key_name                    = "devops"
    vpc_id                      = "vpc-0271c459c930e8e54"
    vpc_security_groups         = ["sg"]
    subnet_id                   = "subnet-011edbedcc5deff88"
    availability_zone           = "us-east-1c"
    root_block_volume_size      = 10
    ports  = [80, 443, 22]
    cidrs  = ["0.0.0.0/0"]
    ebs_block_device = [
        {
          device_name = "/dev/sdf"
          volume_type = "gp3"
          volume_size = 10
          throughput  = 200
          encrypted   = true
        }
    ]
    tags = {
        name = "ec2"
    }
  }
}
