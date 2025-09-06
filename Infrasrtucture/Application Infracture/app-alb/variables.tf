variable "project" {
    default = "web_app"
}

variable "environment" {
    default = "prod"
}

variable "common_tags" {
    default = {
        project = "web_app"
        environment = "prod"
        terraform = "true"
    }
}

variable "zone_id" {
    default = "Z06311461V7HCH4LJMH8W"
}

variable "domain_name" {
    default = "lakshman.site"
}