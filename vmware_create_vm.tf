variable "guestid" { type = "string" }
variable "user" { type = "string" }
variable "password" { type = "string" }
variable "cloudhost" { type = "string" }
variable "datacenter" { type = "string" }
variable "storage" { type = "string" }
variable "pool" { type = "string" }
variable "network" { type = "string" }
variable "template" { type = "string" }
variable "vm" { type = "string" }
variable "cpu" { type = "string" }
variable "memory" { type = "string" }
variable "disk1name" { type = "string" }
variable "disk1size" { type = "string" }
variable "disk2name" { type = "string" }
variable "disk2size" { type = "string" }

provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.cloudhost}"
  allow_unverified_ssl = true
  version = "1.3.3"
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.storage}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${var.cpu}"
  memory   = "${var.memory}"
  guest_id = "${var.guestid}"

  scsi_type = "pvscsi"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
  }

  disk {
    label             = "${var.disk1name}"
    size             = "${var.disk1size}"
  }

  disk {
    label             = "${var.disk2name}"
    size             = "${var.disk2size}"
    unit_number	     = 1
  }


  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    }

}
