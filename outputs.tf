output "input" {
    value = local.raw_settings
}

output "site_tag" {
    value = netbox_extras_tag.site_tag
}

output "site" {
    value = netbox_dcim_site.site
}

output "racks" {
    value = netbox_dcim_rack.racks
}

output "devices" {
    value = netbox_dcim_device.devices
}

output "vlans" {
    value = netbox_ipam_vlan.vlans
}

output "interfaces" {
    value = netbox_dcim_interface.interfaces
}

output "prefixes" {
    value = netbox_ipam_prefix.prefixes
}