resource "aws_instance" "ec2" {
  ami                         = var.ec2_settings["ami"]
  instance_type               = var.ec2_settings["instance_type"]
  associate_public_ip_address = var.ec2_settings["associate_public_ip_address"]
  key_name                    = var.ec2_settings["key_name"]
  subnet_id                   = var.ec2_settings["subnet_id"]
  vpc_security_group_ids      = var.ec2_settings["vpc_security_groups"]
  user_data                   = var.ec2_settings["userdata"] == "gateway" ? data.template_file.userdata_gateway.rendered : var.ec2_settings["userdata"] == "content" ? data.template_file.userdata_content.rendered :  data.template_file.userdata_app.rendered
  #availability_zone           = var.ec2_settings["availability_zone"]
  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_settings["root_block_volume_size"]
  }
iam_instance_profile = var.ec2_settings["instance_profile"]
  dynamic "ebs_block_device" {
    for_each = var.ec2_settings["ebs_block_device"]
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }
  tags = var.ec2_settings["tags"]
}
