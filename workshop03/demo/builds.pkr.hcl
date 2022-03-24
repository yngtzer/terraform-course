build {
    sources = ["source.digitalocean.mydroplet"]

    provisioner ansible {
        playbook_file = "playbook.yml"
    }
}