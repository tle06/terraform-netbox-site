variable "path" {
  description = "The path of the yaml file describing the site."
  type        = string
}

variable "region" {
  description = "The ID of region where the site will be located."
  type        = number
}

variable "tenant" {
  description = "The ID of tenant that will be added to the site."
  type        = number
}
