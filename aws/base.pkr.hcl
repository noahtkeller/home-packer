variable ubuntu-account-id {
  type = string
    default = "099720109477"
}

variable type {
  type = string
  default = "t2.small"
}

source amazon-ebs ubuntu-cloud {
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name = "ubuntu/images/*ubuntu-${var.release}-*-amd64-server-*"
      root-device-type = "ebs"
    }
    owners = [var.ubuntu-account-id]
    most_recent = true
  }
  ami_description = "Ubuntu ${var.release} server amd64 golden image"
  ssh_username = "ubuntu"
  iam_instance_profile = "packer-builder"
}

variable rocky-account-id {
  type = string
  default = "792107900819"
}

source amazon-ebs rocky-cloud {
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name = "Rocky-${var.release}-*x86_64"
      root-device-type = "ebs"
    }
    owners = [var.rocky-account-id]
    most_recent = true
  }
  tags = {
    distro = var.distro
  }
  ami_description = "Rocky Linux ${var.release} server amd64 golden image"
  ssh_username = "rocky"
  iam_instance_profile = "packer-builder"
}

variable release {
  type = string
  default = "focal"
}

variable distro {
  type = string
  default = "ubuntu"
}

build {
  source "amazon-ebs.ubuntu-cloud" {
    name = "ubuntu-base"
    ami_name = "ubuntu-${var.release}-base"
    associate_public_ip_address = true
    ami_virtualization_type = "hvm"
    instance_type = "t2.small"
    region = "us-east-1"
  }

  source "amazon-ebs.rocky-cloud" {
    name = "rocky-base"
    ami_name = "rocky-${var.release}-base"
    associate_public_ip_address = true
    ami_virtualization_type = "hvm"
    instance_type = "t2.small"
    region = "us-east-1"
  }

#  provisioner ansible {
#    playbook_file = "ansible/plays/hardened_server.yml"
#    galaxy_file = "ansible/roles/roles_requirements.yml"
#    roles_path = "ansible/roles/external"
#    ansible_env_vars = ["ANSIBLE_CONFIG=ansible/plays/ansible.cfg"]
#  }
#
#  provisioner inspec {
#    inspec_env_vars = ["CHEF_LICENSE=accept"]
#    profile = "https://github.com/dev-sec/linux-baseline/archive/refs/tags/2.6.0.tar.gz"
#  }
}
