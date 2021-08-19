variable "path" {
  description = "The path of the yaml file describing the site"
  type        = string
}

variable "region" {
  description = ""
  type = number
}

variable "tenant" {
  description = ""
  type = number
}

variable "tags" {
  description = ""
  type = list
}
