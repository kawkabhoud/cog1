data "template_file" "userdata_gateway" {
  template = file("userdata/gateway/gateway.ps1")
}
data "template_file" "userdata_app" {
  template = file("userdata/app/app.ps1")
}
data "template_file" "userdata_content" {
  template = file("userdata/content/content.ps1")
}
