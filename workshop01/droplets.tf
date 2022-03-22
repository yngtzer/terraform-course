resource "local_file" "nginx_conf" {
  filename = "nginx.conf"
  content = templatefile("nginx.conf.tftpl", {
      docker_host_ip = var.docker_host_ip,
      container_ports = [for p in docker_container.dov-container[*].ports : element(p, 0).external]
  })
  file_permission = 0644
}

resource "digitalocean_droplet" "reverse-proxy" {
  image  = "ubuntu-21-10-x64"
  name   = "web-1"
  region = "SGP1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
      data.digitalocean_ssh_key.do_ssh_key.id
  ]

  connection {
    type     = "ssh"
    user     = "root"
    host     = self.ipv4_address
    private_key = file(var.pvt_key)
  }

  provisioner "remote-exec" {
    inline = [
        "apt update",
        "apt install -y nginx",
    ]
  }

  provisioner "file" {
      source = "nginx.conf"
      destination = "/etc/nginx/nginx.conf"
  }

  provisioner "remote-exec" {
      inline = [
          "systemctl restart nginx",
      ]
  }
}

output "nginx-ipv4" {
  value = digitalocean_droplet.reverse-proxy.ipv4_address
}