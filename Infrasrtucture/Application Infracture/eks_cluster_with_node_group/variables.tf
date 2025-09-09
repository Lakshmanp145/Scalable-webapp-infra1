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