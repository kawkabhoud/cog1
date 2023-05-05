resource "aws_db_subnet_group" "default" {
  name       = var.db_settings["db_subnet_group_name"]
  subnet_ids = var.db_settings["db_subnet_group_ids"]

  tags = {
    Name = "Cognos DB subnet group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = var.db_settings["allocated_storage"]
  identifier           = var.db_settings["identifier"]
  engine               = var.db_settings["engine"]
  engine_version       = var.db_settings["engine_version"]
  backup_retention_period = var.db_settings["backup_retention_period"]
  instance_class       = var.db_settings["instance_class"]
  username             = var.db_settings["username"]
  multi_az             = var.db_settings["multi_az"]
  license_model        = var.db_settings["license_model"]
  password             = var.db_settings["password"]
  db_subnet_group_name = aws_db_subnet_group.default.name
  tags = {
    Name = "cognos-db"
    Provisoned = "Terraform"
  }
}
