provider "google" {
 credentials = file("/home/shukla_chandan64/gitpush/account.json")
 project     = "imperial-legacy-232115"
 zone      = "us-west1-a"
}
resource "google_compute_instance" "default" {
 name         = "adhoc-vm"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
#     image = "debian-cloud/debian-9"
      image="ubuntu-os-cloud/ubuntu-1604-lts"
   }
 }
  metadata = {
    ssh-keys = "${"shukla_chandan64"}:${file("/home/shukla_chandan64/code/keyfiles/key.pub")}"
  }
#####  metadata_startup_script = "mkdir -p .ssh;echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOPifSGm9nevsSzAOLWMN0nkg53syJqgsm0Fb8cK9MicsM5sPnqnYVjPPlg58LhrjGRcTzwNMCT2S/PmS/WvJKn0d0W5Z4i/9uFzTpVHAgq30vxzF5INThAshI/tvdZiVLKsy5GWTMYB8Wew5LIa+dUHRGQwTpRFqVON0rkRFfOfX16CFDGW2aTpKwx+PyLzvvgtXgbkcusZ2oqgEXP/+yJ30TzjozG6/xQs/zPmwAvmc+/YYBMkpd3zMmD8zCuwcvyYJOG0pDhu//Xo+GSSZp95hei1qajmfh2I9iBYAjQz7DQII745aLOlYfIfxSVYtXis0m49VAb7FOOsveheZh > .ssh/id_rsa.pub" 
# metadata_startup_script = "sudo apt-get update; sudo apt-get python; sudo apt-get pip;udo apt-get pip; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   subnetwork = "default"
   access_config {
      // Ephemeral IP
    }

 }
}
