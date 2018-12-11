variable "user_name"           { type = "string" }
variable "password"            { type = "string" }
variable "tenant_name"         { type = "string" }
variable "user_domain_name"    { type = "string", default = "Default" }
variable "project_domain_name" { type = "string", default = "Default" }
variable "auth_url"            { type = "string" }
variable "insecure"            { type = "string", default = "false" }
variable "image_name"          { type = "string" }
variable "image_url"           { type = "string" }

provider "openstack" {
  version             = "1.10.0"
  user_name           = "${var.user_name}"
  password            = "${var.password}" 
  tenant_name         = "${var.tenant_name}"
  user_domain_name    = "${var.user_domain_name}" 
  project_domain_name = "${var.project_domain_name}"
  auth_url            = "${var.auth_url}"
  insecure            = "${var.insecure}"
}

resource "openstack_images_image_v2" "image" {
  name   = "${var.image_name}"
  image_source_url = "${var.image_url}"
  container_format = "bare"
  disk_format = "qcow2"
}
