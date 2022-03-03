build {
  source "amazon-ebs.base" {
    name = "ubuntu-k8s"
    ami_name = "ubuntu-${var.release}-k8s-master"
    subnet_filter {
      filters = {
        "tag:Name": "master subnet"
      }
    }
  }

  source "amazon-ebs.base" {
    name = "rocky-k8s"
    ami_name = "rocky-${var.release}-k8s-master"
    subnet_filter {
      filters = {
        "tag:Name": "master subnet"
      }
    }
  }

  provisioner ansible {
    playbook_file = "ansible/plays/k8s.yml"
    galaxy_file = "ansible/roles/roles_requirements.yml"
    roles_path = "ansible/roles/external"
    ansible_env_vars = ["ANSIBLE_CONFIG=ansible/plays/ansible.cfg"]
  }
}
