# Download nginx version 1.17
resource docker_image nginx_img {
  name = "nginx:1.17"
}

resource null_resource init {
  provisioner local-exec {
    command = "sudo mkdir -p /opt/nginx/conf.d/;sudo mkdir -p /var/log/nginx/;sudo cp -f ./nginx_custom.conf /opt/nginx/conf.d/"
  }
}

# start the container
resource docker_container nginx {
  name = "nginx"
  image = docker_image.nginx_img.name
  ports {
    internal = 80
    external = 81
  }


  mounts {
    target = "/etc/nginx/conf.d/"
    source = "/opt/nginx/conf.d/"
    type = "bind"
  }

  mounts {
    target = "/var/log/nginx/"
    source = "/var/log/nginx/"
    type = "bind"
  }

  networks_advanced {
    # change to the desired network name in docker
    name = "compose_bt_admin"
    aliases = ["nginx"]
  }

  depends_on = [null_resource.init]

}

