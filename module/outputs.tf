
output "input" {
    value = local.raw_settings
}

output "setting" {
    value = local.prefixes
}

output "debug" {
    value = netbox_dcim_interface.interfaces
}