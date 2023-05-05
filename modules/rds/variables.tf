variable "db_settings" {
  default = {
    allocated_storage    = 10
    engine               = "sqlserver-se"
    identifier           = "cognosdb1"
    engine_version       = "15.00.4236.7.v1"
    instance_class       = "db.m5.large"
    backup_retention_period = 7
    multi_az             = true
    username             = "Cognos-Administrator"
    license_model        = "license-included"
    password             = "Cognostest123"
  }
}
