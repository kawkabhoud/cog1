output "instance_id" {
value = local.gateway_tier_ec2_ips
}
output "instance_id_testing" {
value = values(local.gateway_tier_ec2_ips)
}
output "lb_settings" {
value = local.lb_settings
}
output "instance_ip" {value=local.ec2_ips}


locals {
  instance_names = ["cognos-content-1", "cognos-content-2", "cognos-gateway-1", "cognos-gateway-2", "cognos-app-1", "cognos-app-2"]
app_tier_ec2_ips={for i in module.app_tier_ec2: i.ec2.tags.Name => i.ec2.private_ip}
gateway_tier_ec2_ips={for i in module.gw_tier_ec2: i.ec2.tags.Name => i.ec2.private_ip}
gateway_tier_ec2_ids={for i in module.gw_tier_ec2: i.ec2.tags.Name => i.ec2.id}
content_tier_ec2_ips={for i in module.content_manager_tier_ec2: i.ec2.tags.Name => i.ec2.private_ip}
ec2_ips=merge(local.app_tier_ec2_ips,local.gateway_tier_ec2_ips,local.content_tier_ec2_ips)
}

resource "aws_route53_record" "ec2_r53_record" {
count = 6

name = "${local.instance_names[count.index]}.ivueba-data-cloud-nonprod.aws.fisv.cloud"
type = "A"
zone_id = "Z086789131SRFNBQ10GXY"

ttl = 300

records = [
  local.ec2_ips[local.instance_names[count.index]]
 ]
}

module "content_manager_tier_ec2" {
    source = "../../modules/ec2"

    for_each = local.content_manager_ec2_settings
    ec2_settings = each.value
    depends_on = [module.roles]
#    iam_instance_profile = module.iam_role.profile.name
}

module "lb" {
    source = "../../modules/lb"
    lb_settings = local.lb_settings
}

module "app_tier_ec2" {
    source = "../../modules/ec2"


    for_each = local.app_ec2_settings
    ec2_settings = each.value
    depends_on = [module.roles]
#    iam_instance_profile = module.iam_role.profile.name
}

module "gw_tier_ec2" {
    source = "../../modules/ec2"

    for_each = local.gw_ec2_settings

    ec2_settings = each.value
    depends_on = [module.roles]
#    iam_instance_profile = module.iam_role.profile.name
}

module "rds" {
    source = "../../modules/rds"


    db_settings = var.db_settings
}


module "sg" {
   for_each = var.sg

  source   = "../../modules/sg"

  name        = each.value.name
  description = each.value.description
  vpc_id      = each.value.vpc_id
  ingress     = each.value.ingress
  egress      = each.value.egress
  tags        = each.value.tags
}
module "roles" {
    source = "../../modules/iam"

    role_name = "test_role"
    policy_name = "test_policy"
    description = "Test policy"
    assume_role_policy = jsonencode({
                                    Version = "2012-10-17"
                                    Statement = [
                                    {
                                        Action = "sts:AssumeRole"
                                        Effect = "Allow"
                                        Sid    = ""
                                        Principal = {
                                        Service = "ec2.amazonaws.com"
                                        }
                                    },
                                    ]
                                })
    policy  =   jsonencode({
                           "Version": "2012-10-17",
                           "Statement": [
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": "arn:aws:s3:::businessanalytics-shared-s3-dev/*"
        }
   ]
                    })
}
locals {
    name_to_role_arn = {for i in module.roles: i.name => i.arn}
    sg_name_to_id = {for i in module.sg: i.sg.name => i.sg.id}
    gw_ec2_settings = {for i,j in var.gw_ec2_settings: i =>
                                {ami = j.ami
                                 instance_type = j.instance_type
                                 instance_profile = j.instance_profile
                                 associate_public_ip_address = j.associate_public_ip_address
                                 key_name = j.key_name
                                 vpc_id = j.vpc_id
                                 vpc_security_groups = concat(j.vpc_security_groups, [for i in j.sg_name: local.sg_name_to_id[i]]) ##
                                 subnet_id = j.subnet_id
                                 root_block_volume_size = j.root_block_volume_size
                                 userdata = j.userdata
                                 ebs_block_device = j.ebs_block_device
                                 tags = j.tags
                                 }
                    }
    app_ec2_settings = {for i,j in var.app_ec2_settings: i =>
                                {ami = j.ami
                                 instance_type = j.instance_type
                                 instance_profile = j.instance_profile
                                 associate_public_ip_address = j.associate_public_ip_address
                                 key_name = j.key_name
                                 vpc_id = j.vpc_id
                                 vpc_security_groups = concat(j.vpc_security_groups, [for i in j.sg_name: local.sg_name_to_id[i]]) ##
                                 subnet_id = j.subnet_id
                                 root_block_volume_size = j.root_block_volume_size
                                 userdata = j.userdata
                                 ebs_block_device = j.ebs_block_device
                                 tags = j.tags
                                 }
                    }
    content_manager_ec2_settings = {for i,j in var.content_manager_ec2_settings: i =>
                                {ami = j.ami
                                 instance_type = j.instance_type
                                 instance_profile = j.instance_profile
                                 associate_public_ip_address = j.associate_public_ip_address
                                 key_name = j.key_name
                                 vpc_id = j.vpc_id
                                 vpc_security_groups = concat(j.vpc_security_groups, [for i in j.sg_name: local.sg_name_to_id[i]]) ##
                                 subnet_id = j.subnet_id
                                 root_block_volume_size = j.root_block_volume_size
                                 userdata = j.userdata
                                 ebs_block_device = j.ebs_block_device
                                 tags = j.tags
                                 }
                    }
    lb_settings = { name = var.lb_settings.name
                 internal = var.lb_settings.internal
                 load_balancer_type = var.lb_settings.load_balancer_type
                 subnets = var.lb_settings.subnets
                 enable_deletion_protection = var.lb_settings.enable_deletion_protection
                 tags = var.lb_settings.tags
                 tg_name = var.lb_settings.tg_name
                 tg443_name = var.lb_settings.tg443_name
                 target_id = values(local.gateway_tier_ec2_ips)
                 tg_port = var.lb_settings.tg_port
                 tg443_port = var.lb_settings.tg443_port
                 tg_protocol = var.lb_settings.tg_protocol
                 tg443_protocol = var.lb_settings.tg443_protocol
                 lstn_port = var.lb_settings.lstn_port
                 lstn443_port = var.lb_settings.lstn443_port
                 lstn_protocol = var.lb_settings.lstn_protocol
                 lstn443_protocol = var.lb_settings.lstn443_protocol
                 vpc_id = var.lb_settings.vpc_id
}
}
