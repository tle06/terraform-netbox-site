output "input" {
  description = "The yaml file converted to varible"
  value       = local.raw_settings
}

output "site_tag" {
  description = "The site tag generated from the site_id value"
  value       = netbox_extras_tag.site_tag
}

output "site" {
  description = "The full site generated"
  value       = netbox_dcim_site.site
}

output "racks" {
  description = "The racks generated and attached to the site"
  value       = netbox_dcim_rack.racks
}

output "devices" {
  description = "The devices generated"
  value       = netbox_dcim_device.devices
}

output "vlans" {
  description = "The VLANs generated"
  value       = netbox_ipam_vlan.vlans
}

output "interfaces" {
  description = "The interfaces attached to the devices"
  value       = netbox_dcim_interface.interfaces
}

output "prefixes" {
  description = "The prefix added to the site."
  value       = netbox_ipam_prefix.prefixes
}
