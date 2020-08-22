provider "google" {
 credentials = file("CREDENTIALS_FILE.json")
 project     = "gcp-v2"
 region      = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }

 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
 
 
 

resource "google_compute_disk" "default" {
  name = "test-disk"
}
resource "google_compute_ssl_policy" "default-ssl" {
  name = "test-ssl-policy"
  min_tls_version = "TLS_1_0"
}
resource "google_compute_firewall" "default_firewall" {
  name = "test-firewall"
  network = "default"
  allow {
   protocol = "icmp"
  }
  destination_ranges = ["0.0.0.0/0"]
}

output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
