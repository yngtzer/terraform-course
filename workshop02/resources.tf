data "digitalocean_ssh_key" "do_ssh_key" {
  name = "digitalocean"
}

output "do_fingerprint" {
  value = data.digitalocean_ssh_key.do_ssh_key.fingerprint
}
