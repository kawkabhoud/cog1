db_settings = {
    db_subnet_group_name = "cognos_subnet_group"
    identifier           = "cognosdb1"
    db_subnet_group_ids  = ["subnet-0ad96b4bf34c23e09","subnet-0af8aa31f24198f7e"]
    engine               = "sqlserver-se"
    engine_version       = "15.00.4236.7.v1"
    db_security_groups   = ["sg-057ca0b593c4af130"]
    publicly_accessible  = false
    instance_class       = "db.m5.large"
    allocated_storage    = 50
    backup_retention_period = 7
    multi_az               = true
    storage_type         = "gp2"
    license_model        = "license-included"
    username             = "admin"
    password             = "Cognostest123"
}
        tags = {
            Name = "cognos-db"
            Provisoned = "Terraform"
        }

lb_settings = {
    name               = "cognos-nlb"
    internal           = true
    load_balancer_type = "network"
    subnets            = ["subnet-0ad96b4bf34c23e09", "subnet-0af8aa31f24198f7e", "subnet-0a8e5759787cb6592"]
    enable_deletion_protection = false
    tags                       = { Environment = "cognos-dev" }
    tg_name                    = "cognos-nlb-tg"
    tg443_name                 = "cognos-nlb-tg443"
    tg_port                    = "80"
    tg443_port                 = "443"
    tg_protocol                = "TCP"
    tg443_protocol                = "TCP"
    lstn_port     = "80"
    lstn443_port  = "443"
    lstn_protocol = "TCP"
    lstn443_protocol = "TCP"
    vpc_id = "vpc-0229bb1cd1c5d1f58"
}
role_name = "cognos-build-role"

gw_ec2_settings = {
    "server1" = {
        ami                         = "ami-0a9ced96c810005f9"
        instance_type               = "t2.2xlarge"
        associate_public_ip_address = false
        instance_profile            = "test_role"
        sg_name                     = ["test", "test1"]
        key_name                    = "cognos-dev"
        vpc_id                      = "vpc-0229bb1cd1c5d1f58"
        vpc_security_groups         = []
        subnet_id                   = "subnet-0ad96b4bf34c23e09"
        root_block_volume_size      = 40
        userdata                    = "gateway"
        ebs_block_device = [
            {
            device_name = "/dev/sdb"
            volume_type = "gp3"
            volume_size = 200
            throughput  = 200
            encrypted   = true
            }
        ]
        tags = {
            Name = "cognos-gateway-1"
            Provisoned = "Terraform"
            "fdc:pp-start" = "0 5 * * *"
            "fdc:pp-stop"  = "0 18 * * *"
        }
    }

    "server2" = {
        ami                         = "ami-0a9ced96c810005f9"
        instance_type               = "t2.2xlarge"
        associate_public_ip_address = false
        instance_profile            = "test_role"
        sg_name                     = ["test", "test1"]  ##
        key_name                    = "cognos-dev"
        vpc_id                      = "vpc-0229bb1cd1c5d1f58"
        vpc_security_groups         = []
        subnet_id                   = "subnet-0af8aa31f24198f7e"
        root_block_volume_size      = 40
        userdata                    = "gateway"
        ebs_block_device = [
            {
            device_name = "/dev/sdb"
            volume_type = "gp3"
            volume_size = 200
            throughput  = 200
            encrypted   = true
            }
        ]
        tags = {
            Name = "cognos-gateway-2"
            Provisoned = "Terraform"
            "fdc:pp-start" = "0 5 * * *"
            "fdc:pp-stop"  = "0 18 * * *"
        }
    }
}
app_ec2_settings = {
    "server1" = {
        ami                         = "ami-0a9ced96c810005f9"
        instance_type               = "t2.2xlarge"
        associate_public_ip_address = false
        instance_profile            = "test_role"
        sg_name                     = ["test", "test1"]  ##
        key_name                    = "cognos-dev"
        vpc_id                      = "vpc-0229bb1cd1c5d1f58"
        vpc_security_groups         = []
        subnet_id                   = "subnet-0ad96b4bf34c23e09"
#        availability_zone           = var.az_group_2
        root_block_volume_size      = 40
        userdata                    = "app"
        ebs_block_device = [
            {
            device_name = "/dev/sdb"
            volume_type = "gp3"
            volume_size = 200
            throughput  = 200
            encrypted   = true
            }
        ]
        tags = {
            Name = "cognos-app-1"
            Provisoned = "Terraform"
            "fdc:pp-start" = "0 5 * * *"
            "fdc:pp-stop"  = "0 18 * * *"
        }
    }

    "server2" = {
        ami                         = "ami-0a9ced96c810005f9"
        instance_type               = "t2.2xlarge"
        associate_public_ip_address = false
        sg_name                     = ["test", "test1"]  ##
        instance_profile            = "test_role"
        key_name                    = "cognos-dev"
        vpc_id                      = "vpc-0229bb1cd1c5d1f58"
        vpc_security_groups         = []
        subnet_id                   = "subnet-0af8aa31f24198f7e"
        root_block_volume_size      = 40
        userdata                    = "app"
        ebs_block_device = [
            {
            device_name = "/dev/sdb"
            volume_type = "gp3"
            volume_size = 200
            throughput  = 200
            encrypted   = true
            }
        ]
        tags = {
            Name = "cognos-app-2"
            Provisoned = "Terraform"
            "fdc:pp-start" = "0 5 * * *"
            "fdc:pp-stop"  = "0 18 * * *"
        }
    }
}

content_manager_ec2_settings = {
    "server1" = {
        ami                         = "ami-0a9ced96c810005f9"
        instance_type               = "t2.2xlarge"
        instance_profile            = "test_role"
        associate_public_ip_address = false
        sg_name                     = ["test", "test1"]  ##
        key_name                    = "cognos-dev"
        vpc_id                      = "vpc-0229bb1cd1c5d1f58"
        vpc_security_groups         = []
        subnet_id                   = "subnet-0ad96b4bf34c23e09"
#        availability_zone           = var.az_group_2
        root_block_volume_size      = 40
        userdata                    = "content"
        ebs_block_device = [
            {
            device_name = "/dev/sdb"
            volume_type = "gp3"
            volume_size = 200
            throughput  = 200
            encrypted   = true
            }
        ]
        tags = {
            Name = "cognos-content-1"
            Provisoned = "Terraform"
            "fdc:pp-start" = "0 5 * * *"
            "fdc:pp-stop"  = "0 18 * * *"
        }
    }

    "server2" = {
        ami                         = "ami-0a9ced96c810005f9"
        instance_type               = "t2.2xlarge"
        instance_profile            = "test_role"
        associate_public_ip_address = false
        sg_name                     = ["test", "test1"]  ##
        key_name                    = "cognos-dev"
        vpc_id                      = "vpc-0229bb1cd1c5d1f58"
        vpc_security_groups         = []
        subnet_id                   = "subnet-0af8aa31f24198f7e"
#        availability_zone           = var.az_group_1
        root_block_volume_size      = 40
        userdata                    = "content"
        ebs_block_device = [
            {
            device_name = "/dev/sdb"
            volume_type = "gp3"
            volume_size = 50
            throughput  = 200
            encrypted   = true
            }
        ]
        tags = {
            Name = "cognos-content-2"
            Provisoned = "Terraform"
            "fdc:pp-start" = "0 5 * * *"
            "fdc:pp-stop"  = "0 18 * * *"

        }
    }
}
sg = {"sg1" =   {   name = "test"
                    description = "test description"
                    vpc_id  = "vpc-06fa7e0afe95c00b1"
                    ingress = { "rule1" = { description      = "TLS from VPC"
                                            from_port        = 443
                                            to_port          = 443
                                            protocol         = "tcp"
                                            cidr_blocks      = ["10.0.0.0/8"]
                                            ipv6_cidr_blocks = []
                                    }
                                "rule2" = { description      = "TLS from VPC"
                                            from_port        = 80
                                            to_port          = 80
                                            protocol         = "tcp"
                                            cidr_blocks      = ["10.0.0.0/8"]
                                            ipv6_cidr_blocks = []
                                        }
                    }

                    egress = { "rule1" = { description      = "TLS from VPC"
                                            from_port        = 0
                                            to_port          = 0
                                            protocol         = "-1"
                                            cidr_blocks      = ["11.0.0.0/8"]
                                            ipv6_cidr_blocks = ["::/0"]
                                        }
                            }
                    tags = {}
                }
        "sg2" =   {   name = "test1"
                    description = "test description"
                    vpc_id  = "vpc-06fa7e0afe95c00b1"
                    ingress = { "rule1" = { description      = "TLS from VPC"
                                            from_port        = 443
                                            to_port          = 443
                                            protocol         = "tcp"
                                            cidr_blocks      = ["11.0.0.0/8"]
                                            ipv6_cidr_blocks = []
                                    }
                                "rule2" = { description      = "TLS from VPC"
                                            from_port        = 80
                                            to_port          = 80
                                            protocol         = "tcp"
                                            cidr_blocks      = ["0.0.0.0/0"]
                                            ipv6_cidr_blocks = []
                                        }
                    }

                    egress = { "rule1" = { description      = "TLS from VPC"
                                            from_port        = 0
                                            to_port          = 0
                                            protocol         = "-1"
                                            cidr_blocks      = ["0.0.0.0/0"]
                                            ipv6_cidr_blocks = ["::/0"]
                                        }
                            }
                    tags = {}
                }
}
