output "input" {
  description = "The site tag generated from the site_id value"
  value       = module.example.input
}

output "site_tag" {
  description = "The site tag generated from the site_id value"
  value       = module.example.site_tag
}

output "site" {
  description = "The full site generated"
  value       = module.example.site
}

output "racks" {
  description = "The racks generated and attached to the site"
  value       = module.example.racks
}

output "devices" {
  description = "The devices generated"
  value       = module.example.devices
}

output "vlans" {
  description = "The VLANs generated"
  value       = module.example.vlans
}

output "interfaces" {
description = "The interfaces attached to the devices"
  value       = module.example.interfaces
}

output "prefixes" {
  description = "The prefix added to the site."
  value       = module.example.prefixes
}
