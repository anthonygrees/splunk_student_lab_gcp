####
## VPC
####
resource "google_compute_network" "vpc_network" {
  count                   = var.create_network ? 1 : 0
  name                    = var.splunk_network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "splunk_subnet" {
  count         = var.create_network ? 1 : 0
  name          = var.splunk_subnet
  ip_cidr_range = var.splunk_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network[0].self_link
}

resource "google_compute_address" "splunk_cluster_master_ip" {
  name         = "splunk-cm-ip"
  address_type = "INTERNAL"
  subnetwork = var.create_network ? google_compute_subnetwork.splunk_subnet[0].self_link : var.splunk_subnet 
}

####
## Firewall Rules
####
resource "google_compute_firewall" "allow_internal" {
  name    = "splunk-network-allow-internal"
  network = var.create_network ? google_compute_network.vpc_network[0].name : var.splunk_network

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_tags = ["splunk"]
  target_tags = ["splunk"]
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "splunk-network-allow-health-checks"
  network = var.create_network ? google_compute_network.vpc_network[0].name : var.splunk_network

  allow {
    protocol = "tcp"
    ports    = ["8089", "8088"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["splunk"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "splunk-network-allow-ssh"
  network = var.create_network ? google_compute_network.vpc_network[0].name : var.splunk_network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["splunk"]
}

resource "google_compute_firewall" "allow_splunk_web" {
  name    = "splunk-network-allow-web"
  network = var.create_network ? google_compute_network.vpc_network[0].name : var.splunk_network

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  target_tags = ["splunk"]
}