variable region {
  type = string
  default = "us-east-1"
}

data amazon-ami base {
  filters = {
    name = "${var.distro}-${var.release}-base"
  }
  owners = ["self"]
  most_recent = true
}

source amazon-ebs base {
  source_ami = data.amazon-ami.base.id
  associate_public_ip_address = "true"
  ami_virtualization_type = "hvm"
  ami_description = "The base updated ${var.distro} image for building all other systems"
  instance_type = var.type
  region = var.region
  ssh_username = var.distro
  iam_instance_profile = "packer-builder"
  vpc_filter {
    filters = {
      "tag:Name": "main vpc",
    }
  }
}
