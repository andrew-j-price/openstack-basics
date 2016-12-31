provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "my_instance" {
  name              = "xenial-andrew"
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
  name       = "lightsail_keypair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "username" {
    value = "${aws_lightsail_instance.my_instance.username}"
}

output "public_ip" {
    value = "${aws_lightsail_instance.my_instance.public_ip_address}"
}
