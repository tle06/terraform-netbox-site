
output "input" {
    value = local.raw_settings
}

output "setting" {
    value = local.prefixes
}

# output "tags" {
#     value = netbox_extras_tag.tags
# }