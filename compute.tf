resource "google_compute_instance" "splunk_cluster_master" {
  name         = local.splunk_cluster_master_name
  machine_type = "n1-standard-4"
  zone = local.zone
  tags = ["splunk"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      type  = "pd-ssd"
      size  = "50"
    }
  }

  network_interface {
    network = var.create_network ? google_compute_network.vpc_network[0].self_link : var.splunk_network
    network_ip = google_compute_address.splunk_cluster_master_ip.address
    subnetwork = var.create_network ? google_compute_subnetwork.splunk_subnet[0].self_link : var.splunk_subnet

    access_config {
      # Ephemeral IP
    }
  }

  metadata = {
    startup-script = data.template_file.splunk_startup_script.rendered
    splunk-role    = "IDX-Master"
    enable-guest-attributes = "TRUE"
  }

  depends_on = [
    google_compute_firewall.allow_internal,
    google_compute_firewall.allow_ssh,
    google_compute_firewall.allow_splunk_web,
  ]
}