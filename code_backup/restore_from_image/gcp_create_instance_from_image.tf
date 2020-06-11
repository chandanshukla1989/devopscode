provider "google" {
 credentials = file("account.json")
 project     = "imperial-legacy-232115"
 zone      = "us-west1-a"
}
data "google_compute_image" "adhocvm-image" {
name="adhocvm-image"
}

resource "google_compute_instance" "testdevvm1" {
  # ...
  name="runner-vm"
  machine_type = "f1-micro"
  zone         = "us-west1-a"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.adhocvm-image.self_link
    }
  }
 metadata = {
    ssh-keys = "${"shukla_chandan64"}:${file("/home/shukla_chandan64/code/keyfiles/key.pub")}"
  }

 network_interface {
   network = "default"
    access_config {
      // Ephemeral IP
    }

 }
}
