variable "user"       { type = "string" }
variable "password"   { type = "string" }
variable "datacenter" { type = "string" }
variable "storage"    { type = "string" }
variable "project"    { type = "string" }
variable "network"    { type = "string" }
variable "cloudhost"  { type = "string" }
variable "vm"         { type = "string" }
variable "template"   { type = "string" }
variable "cluster"    { type = "string" }
variable "secgroup"   { type = "string" }
variable "ip"         { type = "string" }
variable "netmask"    { type = "string" }
variable "gateway"    { type = "string" }
variable "keypair"    { type = "string" }
variable "flavor"     { type = "string" }
variable "disk1name"  { type = "string" }
variable "disk1size"  { type = "string" }
variable "disk2name"  { type = "string" }
variable "disk2size"  { type = "string" }
variable "dnsdomain"  { type = "string" }

provider "openstack" {
  version             = "1.10.0"
  user_name           = "${var.user}"
  password            = "${var.password}" 
  tenant_name         = "${var.project}"
  user_domain_name    = "Default" 
  project_domain_name = "${var.dnsdomain}"
  auth_url            = "https://${var.cloudhost}:5000/v3"
  insecure            = "true"
}

data "openstack_compute_keypair_v2" "keypair" {
  name = "${var.keypair}"
}

data "openstack_images_image_v2" "selected_image" {
  name              = "${var.template}"
}

data "openstack_compute_flavor_v2" "selected_flavor" {
  name              = "${var.flavor}"
}

resource "openstack_compute_instance_v2" "vm" {
  name              = "${var.vm}"
  availability_zone = "${var.cluster}"
  flavor_name       = "${var.flavor}"
  key_pair          = "${var.keypair}"
  security_groups   = ["${var.secgroup}"]
  image_name        = "${var.template}"

  network {
    name            = "${var.network}"
    fixed_ip_v4     = "${var.ip}"
  }

  block_device {
    source_type           = "image"
    uuid                  = "${data.openstack_images_image_v2.selected_image.id}"
    destination_type      = "volume"
    volume_size           = "${data.openstack_compute_flavor_v2.selected_flavor.disk}"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = "${var.disk2size}"
    boot_index            = 1
    delete_on_termination = true
  }
}
