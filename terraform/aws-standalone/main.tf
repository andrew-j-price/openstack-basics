provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_instance" {
  ami = "ami-e13739f6"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.test_keypair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  provisioner "remote-exec" {
    script = "script.sh"
    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  tags {
    name = "terraform-test"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-test-instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "test_keypair" {
    key_name = "test_keypair"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "public_ip" {
    value = "${aws_instance.test_instance.public_ip}"
}
