variable DO_TOKEN {
    type = string
    default = "${env("DO_TOKEN")}"
}

variable droplet_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable droplet_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable droplet_region {
    type = string
    default = "sgp1"
}