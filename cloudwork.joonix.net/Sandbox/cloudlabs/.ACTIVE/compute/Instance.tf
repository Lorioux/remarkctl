
locals {
  google_compute_instance = jsondecode(file("${var.google_compute_instance["argsfile"]}")) #["resources"][0]
  instance_attrs          = { for instance in local.google_compute_instance.instances : ("${instance["index_key"]}") => ("${instance["attributes"]}") }
}

variable "google_compute_instance" {
  type = object({
    names    = list(string)
    argsfile = string
  })
}

resource "google_compute_instance" "instance" {
  for_each = { for attributes in local.instance_attrs : ("${attributes["name"]}") => attributes
  if contains(distinct(var.google_compute_instance["names"]), "${attributes["name"]}") && "${attributes["name"]}" != "" }
  # required fields

  description = each.value["description"]

  zone = each.value["zone"]

  label_fingerprint = each.value["label_fingerprint"]

  metadata_fingerprint = each.value["metadata_fingerprint"]

  name = each.value["name"]
  shielded_instance_config {

  }
  network_interface {
    ipv6_access_type = each.value["network_interface"]["ipv6_access_type"]
    name             = each.value["network_interface"]["name"]

  }
  params {

  }

  metadata_startup_script = each.value["metadata_startup_script"]

  current_status = each.value["current_status"]

  instance_id = each.value["instance_id"]

  min_cpu_platform = each.value["min_cpu_platform"]

  cpu_platform = each.value["cpu_platform"]

  tags_fingerprint = each.value["tags_fingerprint"]
  confidential_instance_config {
    enable_confidential_compute = each.value["confidential_instance_config"]["enable_confidential_compute"]

  }

  hostname = each.value["hostname"]

  machine_type = each.value["machine_type"]
  guest_accelerator {
    count = each.value["guest_accelerator"]["count"]
    type  = each.value["guest_accelerator"]["type"]

  }
  scratch_disk {
    interface = each.value["scratch_disk"]["interface"]

  }

  self_link = each.value["self_link"]
  reservation_affinity {
    type = each.value["reservation_affinity"]["type"]

  }
  boot_disk {
    disk_encryption_key_sha256 = each.value["boot_disk"]["disk_encryption_key_sha256"]

  }
  network_performance_config {
    total_egress_bandwidth_tier = each.value["network_performance_config"]["total_egress_bandwidth_tier"]

  }

  project = each.value["project"]
  scheduling {

  }

}

