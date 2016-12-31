output "elb_dns_name" {
  value = "${aws_elb.testing.dns_name}"
}
