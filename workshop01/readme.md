# Workshop 01 - Terraform

### To retrieve docker pod's port

To access all container ports
```
docker_container.dov-container[*].ports

// return

dov-ports = "49163,49165,49164" -> [
      + [
          + {
              + external = 49163
              + internal = 3000
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            },
        ],
      + [
          + {
              + external = 49165
              + internal = 3000
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            },
        ],
      + [
          + {
              + external = 49164
              + internal = 3000
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            },
        ],
    ]


```
Observe that the response structure is list(list(object))

To get only external ports
```
docker_container.dov-container[*].ports[*].external

// return

dov-ports = "49163,49165,49164" -> [
    + [
        + 49163,
    ],
    + [
        + 49165,
    ],
    + [
        + 49164,
    ],
]
```

To join all external ports and collect as a single string with comma delimited
```
join(",", [for p in docker_container.dov-container[*].ports[*] : element(p, 0).external])
```

### Dynamic populate file based on resource outputs
Using local_file & templatefile
```
resource "local_file" "nginx_conf" {
  filename = "nginx.conf"
  content = templatefile("nginx.conf.tftpl", {
      docker_host_ip = var.docker_host_ip,
      container_ports = [for p in docker_container.dov-container[*].ports : element(p, 0).external]
  })
  file_permission = 0644
}
```
```
// nginx.conf.tftpl
// some other code...

%{~ for port in container_ports ~}
server ${docker_host_ip}:${port};
%{~ endfor ~}

// some other code...
```

### Using remote-exec to run some commands
```
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
```
Assign pvt_key with the value of your private key for the ssh connection.