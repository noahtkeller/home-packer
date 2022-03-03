variable "ubuntu-server-release" {
  type = string
  default = "focal"
}

variable "num-cpus" {
  type = number
  default = 4
}

variable "memory" {
  type = number
  default = 4096
}

variable "display" {
  type = string
  default = "cocoa"
}

variable "ubuntu-checksum" {
  type = string
}

variable "headless" {
  type = bool
  default = false
}

source qemu ubuntu-base-amd64 {
  iso_urls = [
    "images/${var.ubuntu-server-release}-server-cloudimg-amd64.img",
    "https://cloud-images.ubuntu.com/${var.ubuntu-server-release}/current/${var.ubuntu-server-release}-server-cloudimg-amd64.img"
  ]
  iso_checksum = "sha256:${var.ubuntu-checksum}"
  iso_target_path = "images"
  iso_target_extension = "img"
  disk_image = true
  ssh_username = "nkeller"
  ssh_timeout = "20m"
  ssh_private_key_file = "/Users/nkeller/.ssh/noah_keller"
  cd_files = ["./ci-data/user-data"]
  cd_label = "cidata"
  output_directory = "build/ci/ubuntu-amd64"
  format = "qcow2"
  cpus = var.num-cpus
  disk_interface = "virtio"
  boot_wait = "2m30s"
  disk_size = "10G"
  shutdown_command = "shutdown -P now"
  machine_type = "q35"
  memory = var.memory
  display = var.display
  headless = var.headless
}

build {
  source "qemu.ubuntu-base-amd64" {
    vm_name = "ubuntu-amd64.qcow2"
  }
}
