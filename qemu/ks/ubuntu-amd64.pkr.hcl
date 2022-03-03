variable "ubuntu-server-release" {
  type = string
  default = "focal"
}

variable "ubuntu-server-version" {
  type = string
  default = "20.04.3"
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
    "isos/ubuntu-${var.ubuntu-server-version}-live-server-amd64.iso",
    "https://releases.ubuntu.com/${var.ubuntu-server-release}/ubuntu-${var.ubuntu-server-version}-live-server-amd64.iso"
  ]
  iso_checksum = "sha256:${var.ubuntu-checksum}"
  iso_target_path = "isos"
  ssh_username = "root"
  ssh_timeout = "10m"
  output_directory = "build/ks/ubuntu-amd64"
  http_directory = "preseeds"
  format = "qcow2"
  cpus = var.num-cpus
  disk_interface = "virtio"
  boot_wait = "2s"
  disk_size = "10G"
  shutdown_command = "shutdown -P now"
  machine_type = "q35"
  memory = var.memory
  display = var.display
  headless = var.headless
  boot_command = [
    "<esc><wait><esc><wait><f6><wait><esc><bs><bs><bs><bs>",
    "auto ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu-${var.ubuntu-server-release}-amd64.cfg ",
    "--- ",
    "<enter>"
  ]
}

build {
  source "qemu.ubuntu-base-amd64" {
    vm_name = "ubuntu-amd64.qcow2"
  }
}
