provider "aws" {
  region = "${var.region}"
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}

resource "aws_launch_configuration" "testing" {
  image_id        = "${var.ami_id}"
  instance_type   = "${var.instance_flavor}"
  key_name        = "${aws_key_pair.my_keypair.key_name}"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "testing" {
  launch_configuration = "${aws_launch_configuration.testing.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.testing.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 4

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "testing" {
  name               = "terraform-elb"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    lb_port           = "${var.lb_server_port}"
    lb_protocol       = "tcp"
    instance_port     = "${var.web_server_port}"
    instance_protocol = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 2
    interval            = 30
    target              = "HTTP:${var.web_server_port}/"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-sg-elb"

  ingress {
    from_port   = "${var.lb_server_port}"
    to_port     = "${var.lb_server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-sg-instances"

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

  ingress {
    from_port   = "${var.web_server_port}"
    to_port     = "${var.web_server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "my_keypair" {
    key_name = "${var.user_name}_keypair"
    public_key = "${file("${var.ssh_key_file}.pub")}"
}
