data digitalocean_image mydroplet_image {
  name = "mydroplet"
}

resource "digitalocean_droplet" "mydroplet" {
  image  = data.digitalocean_image.mydroplet_image.image
  name   = "web-3"
  region = "SGP1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
      data.digitalocean_ssh_key.do_ssh_key.id
  ]
}

output "mydroplet-ipv4" {
  value = digitalocean_droplet.mydroplet.ipv4_address
}