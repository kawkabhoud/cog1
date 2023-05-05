terraform {
  backend "s3" {
    bucket = "terraform-state-store-us-east-1-724638091496"
    key    = "cognos-test/cognos.tfstate"
    region = "us-east-1"
  }
}

provider aws {
    region = "us-east-1"
}
