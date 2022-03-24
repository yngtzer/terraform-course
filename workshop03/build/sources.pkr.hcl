source "digitalocean" "mydroplet"{
    api_token = var.DO_TOKEN
    region = var.droplet_region
    size = var.droplet_size
    image = var.droplet_image
    ssh_username = "root"
    snapshot_name = "workshop03"
}
