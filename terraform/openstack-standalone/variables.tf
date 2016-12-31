variable "auth_url" {
    default = "https://my_auth_url:5000/v2.0"
}

variable "region" {
    default = "my_region_name"
}

variable "tenant_name" {
    default = "my_tenant_name"
}

variable "user_name" {
    default = "my_user_name"
}

variable "password" {
    default = "Password123"
}

variable "ssh_key_file" {
    default = "~/.ssh/id_rsa"
}

variable "image" {
    default = "Ubuntu-14.04"
}

variable "flavor" {
    default = "nano"
}

variable "ssh_user_name" {
    default = "ubuntu"
}

variable "external_gateway" {
    default = "public"
}

variable "pool" {
    default = "public"
}
