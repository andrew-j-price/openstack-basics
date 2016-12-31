provider "aws" {
  region = "us-east-1"
}

variable "server_names" {
  description = "Create lightsail instances with these names"
  type = "list"
  default = ["lucas", "caroline"]
}

resource "aws_lightsail_instance" "my_instance" {
  count             = "${length(var.server_names)}"
  name              = "xenial-${element(var.server_names, count.index)}"
  availability_zone = "us-east-1b"
  blueprint_id      = "ubuntu_16_04"
  bundle_id         = "nano_1_0"
  key_pair_name     = "${aws_lightsail_key_pair.my_keypair.name}"
  user_data         = "${data.template_file.user_data.rendered}"
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}

resource "aws_lightsail_key_pair" "my_keypair" {
  name       = "my_keypair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "public_ip" {
  value = "${join(" ",aws_lightsail_instance.my_instance.*.public_ip_address)}"
}
