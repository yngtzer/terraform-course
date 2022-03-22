data "digitalocean_ssh_key" "do_ssh_key" {
  name = "digitalocean"
}

output "do_fingerprint" {
  value = data.digitalocean_ssh_key.do_ssh_key.fingerprint
}

resource "docker_image" "dov-image" {
  name = "chukmunnlee/dov-bear:v2"
}

resource "docker_container" "dov-container" {
  count = 3
  image = docker_image.dov-image.latest
  name  = "dov-${count.index}"
  ports {
      internal = 3000
    #   external = 8080
  }
}

output "dov-names" {
  value = docker_container.dov-container[*].name
}

output "dov-ports" {
  value = join("," , [for z in docker_container.dov-container[*].ports : element(z, 0).external])
}