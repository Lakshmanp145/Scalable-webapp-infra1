variable "project" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
    }
}

variable "domain_name" {
    default = "lakshman.site"
}


variable "zone_id" {
    default = "Z06311461V7HCH4LJMH8W"
}