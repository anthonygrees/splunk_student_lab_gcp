variable "splunk_password" {
  description = "Password for Splunk Admin"
}

variable "project" {
  description = "Project for Splunk deployment"
}

variable "region" {
  description = "Region to deploy to"
}

variable "zone" {
  description = "Zone to deploy master and deployer into"
  default = ""
}

variable "creds" {
  description = "Link to your GCP Cred"
  default = ""
}

variable "splunk_network" {
  description = "Network to attach Splunk nodes to"
  default = "splunk-network"
}

variable "splunk_subnet" {
  description = "Subnet to attach Splunk nodes to"
  default = "splunk-subnet"
}

variable "splunk_subnet_cidr" {
  description = "Subnet CIDR to attach Splunk nodes to"
  default = "192.168.0.0/16"
}

variable "create_network" {
  description = "Create Splunk Network (true or false)"
  type = bool
  default = true
}