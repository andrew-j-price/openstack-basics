variable "region" {
    default = "us-east-1"
}

variable "lb_server_port" {
  description = "Web Service Port on ELB"
  default     = 80
}

variable "web_server_port" {
  description = "Web Service Port on Instances"
  default     = 5000
}

variable "ami_id" {
    default = "ami-e13739f6"
}

variable "instance_flavor" {
    default = "t2.micro"
}

variable "ssh_key_file" {
    default = "~/.ssh/id_rsa"
}

variable "user_name" {
    default = "andrew"
}
