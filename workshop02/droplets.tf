resource "digitalocean_droplet" "my-instance" {
  image  = "ubuntu-21-10-x64"
  name   = "web-1"
  region = "SGP1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
      data.digitalocean_ssh_key.do_ssh_key.id
  ]
}

output "nginx-ipv4" {
  value = digitalocean_droplet.my-instance.ipv4_address
}

resource "local_file" "inventory_yml" {

  provisioner "local-exec" {
    command = "ssh-keyscan -H ${digitalocean_droplet.my-instance.ipv4_address}"
  }

  filename = "inventory.yml"
  content = templatefile("inventory.yml.tftpl", {
      host_ip = digitalocean_droplet.my-instance.ipv4_address,
      private_key = var.private_key
      code_server_password = var.code_server_password
      code_server_domain = "code-${digitalocean_droplet.my-instance.ipv4_address}.nip.io"
  })
  file_permission = 0644
}