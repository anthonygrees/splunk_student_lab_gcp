terraform {
  required_version = "~> 0.12.24"
  # experiments = [variable_validation]
}

provider "google" {
  credentials = file("${var.creds}")

  project = var.project
  region  = var.region
#  version = "~> 2.14"
}

provider "google-beta" {
  credentials = file("${var.creds}")
  
  project = var.project
  region  = var.region
#  version = "~> 2.14"
}

 locals {
   splunk_cluster_master_name = "splunk-cluster-master"
   zone    = var.zone == "" ? data.google_compute_zones.available.names[0] : var.zone
 }

data "template_file" "splunk_startup_script" {
  template = file(format("${path.module}/startup_script.sh.tpl"))

  vars = {
    splunk_password              = var.splunk_password
  }

#   depends_on = [
#     google_compute_address.splunk_cluster_master_ip,
#     google_compute_address.splunk_deployer_ip,
#   ]
 }

data "google_compute_zones" "available" {
    region = var.region
}

output "splunk_url" {
  value = "http://${google_compute_instance.splunk_cluster_master.network_interface.0.access_config.0.nat_ip}:8000"
}