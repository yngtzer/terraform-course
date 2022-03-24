data digitalocean_image mydroplet_image {
  name = "workshop03"
}

resource "digitalocean_droplet" "mydroplet" {
  image  = data.digitalocean_image.mydroplet_image.image
  name   = "code-server"
  region = "SGP1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
      data.digitalocean_ssh_key.do_ssh_key.id
  ]
}

output "mydroplet-ipv4" {
  value = digitalocean_droplet.mydroplet.ipv4_address
}

resource "local_file" "inventory_yml" {

  provisioner "local-exec" {
    command = "ssh-keyscan -H ${digitalocean_droplet.mydroplet.ipv4_address}"
  }

  filename = "inventory.yml"
  content = templatefile("inventory.yml.tftpl", {
      host_ip = digitalocean_droplet.mydroplet.ipv4_address,
      private_key = var.private_key
      code_server_password = var.code_server_password
      code_server_domain = "code-${digitalocean_droplet.mydroplet.ipv4_address}.nip.io"
  })
  file_permission = 0644

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yml playbook-update.yml"
  }
}

output "coder-server-url" {
  value = "code-${digitalocean_droplet.mydroplet.ipv4_address}.nip.io"
}

